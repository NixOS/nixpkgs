/* Copyright 2020 Oliver Smith
 * SPDX-License-Identifier: GPL-3.0-or-later */
import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3
import QtQuick.VirtualKeyboard 2.1

Item {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: parent.right
    width: parent.width
    height: parent.height

    TextField {
        id: username
        anchors.top: parent.top
        placeholderText: qsTr("SSH username")
        inputMethodHints: Qt.ImhPreferLowercase
        onTextChanged: validateSshdUsername(username, errorTextUsername)
        text: config.sshdUsername

        onActiveFocusChanged: {
            if(activeFocus) {
                Qt.inputMethod.update(Qt.ImQueryInput);
            }
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Text {
        id: errorTextUsername
        anchors.top: username.bottom
        visible: false
        wrapMode: Text.WordWrap

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    TextField {
        id: password
        anchors.top: errorTextUsername.bottom
        placeholderText: qsTr("SSH password")
        echoMode: TextInput.Password
        onTextChanged: validateSshdPassword(password, passwordRepeat,
                                           errorTextPassword)
        text: config.sshdPassword

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    TextField {
        id: passwordRepeat
        anchors.top: password.bottom
        placeholderText: qsTr("SSH password (repeat)")
        echoMode: TextInput.Password
        onTextChanged: validateSshdPassword(password, passwordRepeat,
                                           errorTextPassword)
        text: config.sshdPassword

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Text {
        id: errorTextPassword
        anchors.top: passwordRepeat.bottom
        visible: false
        wrapMode: Text.WordWrap

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }
    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: errorTextPassword.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Continue")
        onClicked: {
            if (validateSshdUsername(username, errorTextUsername) &&
                validateSshdPassword(password, passwordRepeat,
                                    errorTextPassword)) {
                config.sshdUsername = username.text;
                config.sshdPassword = password.text;

                navTo("fde_confirm");
            }
        }
    }
}
