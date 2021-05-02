/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
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
    property var placeholder: (config.userPasswordNumeric
                               ? "PIN"
                               : "Password")
    property var hints: (config.userPasswordNumeric
                         ? Qt.ImhDigitsOnly
                         : Qt.ImhPreferLowercase)
    property var validateFunc: (config.userPasswordNumeric
                                ? validatePin
                                : validatePassword);


    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: parent.right
    width: parent.width
    height: parent.height

    Text {
        id: description
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        wrapMode: Text.WordWrap

        text: (function() {
            if (config.userPasswordNumeric) {
                return "Set the numeric password of your user. The" +
                       " lockscreen will ask for this PIN. This is" +
                       " <i>not</i> the PIN of your SIM card. Make sure to" +
                       " remember it.";
            } else {
                return "Set the password of your user. The lockscreen will" +
                      " ask for this password. Make sure to remember it.";
            }
        }())

        width: 500
    }

    TextField {
        id: userPass
        anchors.top: description.bottom
        placeholderText: qsTr(placeholder)
        echoMode: TextInput.Password
        onTextChanged: validateFunc(userPass, userPassRepeat, errorText)
        text: config.userPassword

        /* Let the virtual keyboard change to digits only */
        inputMethodHints: hints
        onActiveFocusChanged: {
            if(activeFocus) {
                Qt.inputMethod.update(Qt.ImQueryInput)
            }
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    TextField {
        id: userPassRepeat
        anchors.top: userPass.bottom
        placeholderText: qsTr(placeholder + " (repeat)")
        inputMethodHints: hints
        echoMode: TextInput.Password
        onTextChanged: validateFunc(userPass, userPassRepeat, errorText)
        text: config.userPassword

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Text {
        anchors.top: userPassRepeat.bottom
        id: errorText
        visible: false
        wrapMode: Text.WordWrap

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        width: 500
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: errorText.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Continue")
        onClicked: {
            if (validateFunc(userPass, userPassRepeat, errorText)) {
                config.userPassword = userPass.text;
                navNext();
            }
        }
    }
}
