/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   Copyright 2015, Teo Mrnjavac <teo@kde.org>
 *   Copyright 2018, Adriaan de Groot <groot@kde.org>
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

import QtQuick 2.5;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    mouseNavigation: false /* Only the fwd/back buttons */
    loopSlides: false
    
    BackButton {
        width: 60
        height: 60
        source: "go-previous.svgz"
    }
    
    ForwardButton {
        width: 60
        height: 60
        source: "go-next.svgz"
    }

    SlideCounter {}
    
    Slide {
        /* This first slide ignores the "normal" slide layout and places
         * an image and text by itself. The anchors need to be connected
         * to place the items properly.
         */
        Image {
            id: background1  // Must be unique
            source: "squid.png"
            width: 200; height: 200
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }
        Text {
            anchors.horizontalCenter: background1.horizontalCenter
            anchors.top: background1.bottom
            text: qsTr("This is a customizable QML slideshow.")
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
        }
    }

    Slide {
        /* Make this one narrower to prevent overlap of wide text with nav buttons */
        width: parent.width * 0.9 - 120
        x: parent.width * 0.05 + 60
        /* For just a slide with text, things can be simplified using properties */
        title: qsTr("Welcome to Fancy GNU/Linux.")
        centeredText: qsTr("This is example branding for your GNU/Linux distribution. " +
                "Long texts in the slideshow are translated and word-wrapped appropriately. " +
                "Calamares is a distribution-independent installer framework. ")
    }

    Slide {
        centeredText: qsTr("This is a third Slide element.")
    }

    Slide {
        /* Note that these overlap because both are centered. The z-order puts the background 
         * in back. While you can use the properties of the Slide, it's not easy to get at
         * the anchors of the items.
         */
        Image {
            id: background4
            source: "squid4.png"
            width: 200; height: 200
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            z: -1
        }
        centeredText: qsTr("This is a fourth Slide element.")
    }
    
    Slide {
        title: qsTr("Slide number five")
        writeInText: qsTr("This is example branding for your GNU/Linux distribution. " +
                "Long texts in the slideshow are translated and word-wrapped appropriately. " +
                "Calamares is a distribution-independent installer framework. ")
    }
    
    Slide {
        title: qsTr("Slide number five")
        content: [ 
            qsTr("Welcome to Fancy GNU/Linux."), 
            qsTr("This is a customizable QML slideshow."),
            qsTr("This is a third Slide element.")
            ]
    }
}
