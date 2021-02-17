/* === This file is part of Calamares Extensions - <http://github.com/calamares-extensions> ===
 *
 * SPDX-FileCopyrightText: 2021 Adriaan de Groot <groot@kde.org>
 * SPDX-License-Identifier: BSD-2-Clause
 */

/* An *ImageSlide* is a *Slide* (it offers the API that *Presentation*
 * expects) while displaying only a single image. This is useful
 * for presentations that are all images, with no interaction or text.
 */

import QtQuick 2.5

/* To use an *ImageSlide*, instantiate it inside your *Presentation*
 * and set the *src* property to a path to an image file in a supported
 * format. Relative paths are ok.
 */
Item {
    id: imageslide

    /* Slides should be non-visible at the start; the *Presentation*
     * handles visibility (so that one slide at a time is visible).
     */
    visible: false
    /* Make this item fill up the parent, so that alignment of the
     * image (below) works out to "middle of the parent".
     */
    anchors.fill: parent

    /* The *Presentation* manages visibility of children that have
     * attribute *isSlide* and *isSlide* is set to *true*. Other
     * children are ignored, so we need to set this so that the
     * *ImageSlide* elements are treated like slides.
     */
    property bool isSlide: true;
    /* The *Presentation* allows slides to have notes, so just leave
     * an empty string here.
     */
    property string notes;


    /* This is the important property for *ImageSlide*: the path to the
     * image to display. When instantiating *ImageSlide*, set this for
     * each instance. Relative paths are ok.
     */
    property string src;

    /* The image itself. It has fixed sizes (300x150px). You could set
     * an aspect ratio here (e.g. `height: width / 2`) as well.
     *
     * This binds the image source (filename) to the string *src*
     * in the *ImageSlide* element, for convenience in setting things
     * up in the overall slideshow. If you want to make width and
     * height configurable, add a property above and then bind to
     * them from the Image element.
     */
    Image {
        id: image
        source: src
        width: 300
        height: 150
        anchors.centerIn: parent
    }
}
