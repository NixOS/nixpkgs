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
        id: mainText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 30
        wrapMode: Text.WordWrap

	text: "Are you sure that you want to overwrite the internal storage?" +
	      "<br><br>" +
	      "<b>All existing data on the device will be lost!</b>"
        width: 500
    }

    Button {
        id: firstButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: mainText.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("Yes")
        onClicked: {
            navNext();
        }
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: firstButton.bottom
        anchors.topMargin: 40
        width: 500

        text: qsTr("No")
        onClicked: {
            navBack();
        }
    }
}
