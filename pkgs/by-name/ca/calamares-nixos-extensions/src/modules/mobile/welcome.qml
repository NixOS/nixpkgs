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

Page
{
    id: welcome

    Item {
        id: appContainer
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        Item {
            width: parent.width
            height: parent.height

            Image {
                id: logo
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50
                height: 250
                fillMode: Image.PreserveAspectFit
                source: "file:///usr/share/calamares/branding/default-mobile/logo.png"
            }
            Text {
                id: welcomeText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: logo.bottom
                anchors.topMargin: 50
                horizontalAlignment: Text.AlignRight
                text: "You are about to install<br>" +
                      "<b>" + config.osName +
                      " " + config.version + "</b><br>" +
                      "user interface " +
                      "<b>" + config.userInterface + "</b><br>" +
                      "architecture " +
                      "<b>" + config.arch + "</b><br>" +
                      "on your " +
                      "<b>" + config.device + "</b><br>"
                width: 500
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: welcomeText.bottom
                anchors.topMargin: 50
                width: 500

                text: qsTr("Continue")
                onClicked: navTo("default_pin")
            }
        }
    }
}
