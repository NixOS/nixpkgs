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
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: parent.right
    width: parent.width
    height: parent.height

    Text {
        id: welcomeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        wrapMode: Text.WordWrap

        text: "If you don't know what SSH is, choose 'disable'.<br>" +
              "<br>" +
              "With 'enable', you will be asked for a second username and" +
              " password. You will be able to login to the SSH server with" +
              " these credentials via USB (172.16.42.1), Wi-Fi and possibly" +
              " cellular network. It is recommended to replace the password" +
              " with an SSH key after the installation.<br>" +
              "<br>" +
              "More information:<br>" +
              "https://postmarketos.org/ssh"

        width: 500
    }

    Button {
        id: enableButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: welcomeText.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Enable")
        onClicked: {
            config.isSshEnabled = true;
            navTo("ssh_credentials");
        }
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: enableButton.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Disable")
        onClicked: {
            config.isSshEnabled = false;
            navTo("fde_confirm");
        }
    }
}
