/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2015, Teo Mrnjavac <teo@kde.org>
 *
 *   Calamares is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Calamares is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    Timer {
        id: advanceTimer
        interval: 5000
        running: false
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }
    
    Slide {
        anchors.fill: parent

        Image {
            id: background
            source: "1.svg"
            anchors.fill: parent
        
            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: -125
                font.pixelSize: parent.width *.015
                color: 'white'
                text: qsTr("Here the actual install of KaOS will start.<br/>"+
                    "Use the left <b>mouse button</b> to go to the next slide, right for previous.<br/>"+
                    "After creating your chosen disk setup in the first 10 % <br/>"+
                    "the full copying of the ISO will take the longest of this install phase <br/>"+
                    "and will run until approximately 30%.<br/>")
                wrapMode: Text.WordWrap
                width: 500
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    Slide {
        anchors.fill: parent

        Image {
            id: background1
            source: "2.svg"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: 250
                font.pixelSize: parent.width *.015
                color: 'white'
                text: qsTr("After the ISO is copied some 25 post-install modules will run.<br/>"+
                    "This includes setting user specific options, <br/>"+
                    "removing Live Session only packages<br/>"+
                    "and adjusting hardware setup.<br/>")
                wrapMode: Text.WordWrap
                width: 450
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    Slide {
        anchors.fill: parent

        Image {
            id: background2
            source: "3.svg"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: -100
                font.pixelSize: parent.width *.015
                color: 'white'
                text: qsTr("The default Office Suite is Calligra.<br/>"+
                    "LibreOffice is available in the repositories. <br/>")
                wrapMode: Text.WordWrap
                width: 450
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
    
    Slide {
        anchors.fill: parent

        Image {
            id: background3
            source: "4.svg"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: 250
                font.pixelSize: parent.width *.015
                color: 'white'
                text: qsTr("Qt/KDE specific internet applications include the <br/>"+
                    "Qupzilla web-browser and kde-telepathy for <br/>"+
                    "chat and Instant Messaging. <br/>")
                wrapMode: Text.WordWrap
                width: 450
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
    
    Slide {
        anchors.fill: parent

        Image {
            id: background4
            source: "5.svg"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: -200
                font.pixelSize: parent.width *.015
                color: 'white'
                text: qsTr("For package management Octopi is the GUI application.<br/>")
                wrapMode: Text.WordWrap
                width: 450
                horizontalAlignment: Text.Center
            }
        }
    }
    
    Slide {
        anchors.fill: parent

        Image {
            id: background5
            source: "6.svg"
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 0
                anchors.horizontalCenterOffset: 250
                font.pixelSize: parent.width *.015
                color: 'white'
                text: qsTr("May using KaOS be a pleasant experience for you.")
                wrapMode: Text.WordWrap
                width: 450
                horizontalAlignment: Text.Center
            }
        }
    }

    Component.onCompleted: advanceTimer.running = true
}
