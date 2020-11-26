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
    property var screen: "welcome"
    property var screenPrevious: []
    property var titles: {
        "welcome": null, /* titlebar disabled */
        "default_pin": "Lockscreen PIN",
        "ssh_confirm": "SSH server",
        "ssh_credentials": "SSH credentials",
        "fde_confirm": "Full disk encryption",
        "fde_pass": "Full disk encryption",
        "install_confirm": "Ready to install",
        "wait": null
    }
    /* Only allow characters, that can be typed in with the initramfs on-screen keyboard
     * (osk-sdl: see src/keyboard.cpp). FIXME: make configurable, but keep this as default? */
     property var allowed_chars:
        /* layer 0 */ "abcdefghijklmnopqrstuvwxyz" +
        /* layer 1 */ "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        /* layer 2 */ "1234567890" + "@#$%&-_+()" + ",\"':;!?" +
        /* layer 3 */ "~`|·√πτ÷×¶" + "©®£€¥^°*{}" + "\\/<>=[]" +
        /* bottom row */ " ."

    Item {
        id: appContainer
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: inputPanel.top
        Item {
            width: parent.width
            height: parent.height

            Rectangle {
                id: mobileNavigation
                width: parent.width
                height: 60
                color: "#e6e4e1"
                Layout.fillWidth: true

                border.width: 1
                border.color: "#a7a7a7"

                anchors.left: parent.left
                anchors.right: parent.right

                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: 6

                    Button {
                        Layout.leftMargin: 6
                        id: mobileBack
                        text: "<"

                        background: Rectangle {
                            implicitWidth: 32
                            implicitHeight: 30
                            border.color: "#c1bab5"
                            border.width: 1
                            radius: 4
                            color: mobileBack.down ? "#dbdbdb" : "#f2f2f2"
                        }

                        onClicked: navBack()
                    }
                    Rectangle {
                        implicitHeight: 30
                        Layout.fillWidth: true
                        color: "#e6e4e1"

                        Text {
                            id: mobileTitle
                            text: ""
                            color: "#303638"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Rectangle {
                        color: "#e6e4e1"
                        Layout.rightMargin: 6
                        implicitWidth: 32
                        implicitHeight: 30
                        id: filler
                    }
                }
            }

            Loader {
                id: load
                anchors.left: parent.left
                anchors.top: mobileNavigation.bottom
                anchors.right: parent.right
            }
        }
    }
    InputPanel {
        id: inputPanel
        y: Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Timer {
        id: timer
    }

    /* Navigation related */
    function navTo(name, historyPush=true) {
        if (historyPush)
            screenPrevious.push(screen);
        screen = name;
        load.source = name + ".qml";
        mobileNavigation.visible = (titles[name] !== null);
        mobileTitle.text = "<b>" + titles[name] + "</b>";
        Qt.inputMethod.hide();
    }
    function navFinish() {
        /* Show a waiting screen and wait a second (so it can render), then let
         * MobileQmlViewStep.cpp::onLeave() create the (encrypted) partition
         * and mount it. We can't have this as proper job due to ondev#18. */
        navTo("wait");
        timer.interval = 1000;
        timer.repeat = false;
        timer.triggered.connect(ViewManager.next);
        timer.start();
    }
    function navBack() {
        if (screenPrevious.length)
            return navTo(screenPrevious.pop(), false);
        ViewManager.back();
    }
    function onActivate() {
        navTo(screen, false);
    }

    /* Input validation: show/clear failures */
    function validationFailure(errorText, message="") {
        errorText.text = message;
        errorText.visible = true;
        return false;
    }
    function validationFailureClear(errorText) {
        errorText.text = "";
        errorText.visible = false;
        return true;
    }

    /* Input validation: user-screens (default_pin, ssh_credentials) */
    function validatePin(userPin, userPinRepeat, errorText) {
        var pin = userPin.text;
        var repeat = userPinRepeat.text;

        if (pin == "")
            return validationFailure(errorText);

        if (!pin.match(/^[0-9]*$/))
            return validationFailure(errorText,
                                     "Only digits are allowed.");

        if (pin.length < 5)
            return validationFailure(errorText,
                                     "Too short: needs at least 5 digits.");

        if (repeat == "")
            return validationFailure(errorText);

        if (repeat != pin)
            return validationFailure(errorText,
                                     "The PINs don't match.");
                             
        return validationFailureClear(errorText);
    }
    function validateSshdUsername(username, errorText) {
        var name = username.text;
        var reserved = [ /* FIXME: make configurable */
            config.username,
            "adm",
            "at ",
            "bin",
            "colord",
            "cron",
            "cyrus",
            "daemon",
            "ftp",
            "games",
            "geoclue",
            "guest",
            "halt",
            "lightdm",
            "lp",
            "mail",
            "man",
            "messagebus",
            "news",
            "nobody",
            "ntp",
            "operator",
            "polkitd",
            "postmaster",
            "pulse",
            "root",
            "shutdown",
            "smmsp",
            "squid",
            "sshd",
            "sync",
            "uucp",
            "vpopmail",
            "xfs",
        ]

        /* Validate characters */
        for (var i=0; i<name.length; i++) {
            if (i) {
                if (!name[i].match(/^[a-z0-9_-]$/))
                    return validationFailure(errorText,
                                             "Characters must be lowercase" +
                                             " letters, numbers,<br>" +
                                             " underscores or minus signs.");
            } else {
                if (!name[i].match(/^[a-z_]$/))
                    return validationFailure(errorText,
                                             "First character must be a" +
                                             " lowercase letter or an" +
                                             " underscore.");
            }
        }

        /* Validate against reserved usernames */
        for (var i=0;i<reserved.length;i++) {
            if (name == reserved[i])
                return validationFailure(errorText, "Username '" +
                                                    reserved[i] +
                                                    "' is reserved.")
        }

        /* Passed */
        return validationFailureClear(errorText);
    }
    function validateSshdPassword(password, passwordRepeat, errorText) {
        var pass = password.text;
        var repeat = passwordRepeat.text;

        if (pass == "")
            return validationFailure(errorText);

        if (pass.length < 8)
            return validationFailure(errorText,
                                     "Too short: needs at least 8" +
                                     " characters.");

        if (repeat == "")
            return validationFailure(errorText);

        if (pass != repeat)
            return validationFailure(errorText, "Passwords don't match.");

        return validationFailureClear(errorText);
    }

    /* Input validation: fde_pass */
    function check_chars(input) {
        for (var i = 0; i < input.length; i++) {
            if (allowed_chars.indexOf(input[i]) == -1)
                return false;
        }
        return true;
    }
    function allowed_chars_multiline() {
        /* return allowed_chars split across multiple lines */
        var step = 20;
        var ret = "";
        for (var i = 0; i < allowed_chars.length + step; i += step)
            ret += allowed_chars.slice(i, i + step) + "\n";
        return ret.trim();
    }
    function validatePassword(password, passwordRepeat, errorText) {
        var pass = password.text;
        var repeat = passwordRepeat.text;

        if (pass == "")
            return validationFailure(errorText);

        if (!check_chars(pass))
            return validationFailure(errorText,
                                     "The password must only contain" +
                                     " these characters, others cannot be" +
                                     " typed in at boot time:\n" +
                                     "\n" +
                                     allowed_chars_multiline());

        if (pass.length < 8)
            return validationFailure(errorText,
                                     "Too short: needs at least 8" +
                                     " characters.");

        if (repeat == "")
            return validationFailure(errorText);

        if (pass != repeat)
            return validationFailure(errorText, "Passwords don't match.");

        return validationFailureClear(errorText);
    }
}
