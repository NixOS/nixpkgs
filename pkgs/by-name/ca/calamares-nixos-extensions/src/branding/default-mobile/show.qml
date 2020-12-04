/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    Slide {
        Image {
            id: background
            source: "logo.png"
            height: 250
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
        }
    }
}
