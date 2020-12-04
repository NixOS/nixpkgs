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
        id: password
        anchors.top: parent.top
        placeholderText: qsTr("Password")
        inputMethodHints: Qt.ImhPreferLowercase
        echoMode: TextInput.Password
        onTextChanged: validatePassword(password, passwordRepeat,
                                        errorText)
        text: config.fdePassword

        onActiveFocusChanged: {
            if(activeFocus) {
                Qt.inputMethod.update(Qt.ImQueryInput);
            }
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    TextField {
        id: passwordRepeat
        anchors.top: password.bottom
        placeholderText: qsTr("Password (repeat)")
        echoMode: TextInput.Password
        onTextChanged: validatePassword(password, passwordRepeat,
                                        errorText)
        text: config.fdePassword

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Text {
        id: errorText
        anchors.top: passwordRepeat.bottom
        visible: false

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
        wrapMode: Text.WordWrap
    }
    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: errorText.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Continue")
        onClicked: {
            if (validatePassword(password, passwordRepeat, errorText)) {
                config.fdePassword = password.text;
                navTo("install_confirm");
            }
        }
    }
}
