import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/chat.dart';


import 'package:flutter_app/utils/colors.dart';

class UserChat extends StatefulWidget {
  const UserChat({super.key});

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  String? currentUid;

  @override
  void initState() {
    super.initState();
    currentUid = getCurrentUID();
  }

  String? getCurrentUID() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
              'username',
              //isGreaterThanOrEqualTo: searchController.text,
            )
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> filteredUsers =
              (snapshot.data! as QuerySnapshot)
                  .docs
                  .where((doc) => doc['uid'] != currentUid)
                  .toList();
          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverID: filteredUsers[index]['uid'],
                      receiverEmail:filteredUsers[index]['email'] ,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      filteredUsers[index]['photoUrl'],
                    ),
                    radius: 16,
                  ),
                  title: Text(
                    filteredUsers[index]['username'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
