import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    function nextSlide() {
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 20000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        Text {
            id: text1
            anchors.centerIn: parent
            text: "Reproducible"
            font.pixelSize: 30
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
            color: "#6586C8"
        }
        Image {
            id: background1
            source: "gfx-landing-reproducible.png"
            width: 200; height: 200
            fillMode: Image.PreserveAspectFit
            anchors.bottom: text1.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: background1.horizontalCenter
            anchors.top: text1.bottom
            text: "Nix builds packages in isolation from each other.<br/>"+
                  "This ensures that they are reproducible and don't<br/>"+
                  "have undeclared dependencies, so <b>if a package<br/>"+
                  "works on one machine, it will also work on another.</b>"
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
        }
    }

    Slide {
        Text {
            id: text2
            anchors.centerIn: parent
            text: "Declarative"
            font.pixelSize: 30
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
            color: "#6586C8"
        }
        Image {
            id: background2
            source: "gfx-landing-declarative.png"
            width: 200; height: 200
            fillMode: Image.PreserveAspectFit
            anchors.bottom: text2.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: background2.horizontalCenter
            anchors.top: text2.bottom
            text: "Nix makes it <b>trivial to share development and build<br/>"+
                  "environments</b> for your projects, regardless of what<br/>"+
                  "programming languages and tools you’re using."
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
        }
    }

    Slide {
        Text {
            id: text3
            anchors.centerIn: parent
            text: "Reliable"
            font.pixelSize: 30
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
            color: "#6586C8"
        }
        Image {
            id: background3
            source: "gfx-landing-reliable.png"
            width: 200; height: 200
            fillMode: Image.PreserveAspectFit
            anchors.bottom: text3.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.horizontalCenter: background3.horizontalCenter
            anchors.top: text3.bottom
            text: "Nix ensures that installing or upgrading one package<br/>"+
                  "<b>cannot break other packages.</b> It allows you to <b>roll<br/>"+
                  "back to previous versions,</b> and ensures that no<br/>"+
                  "package is in an inconsistent state during an<br/>"+
                  "upgrade."
            wrapMode: Text.WordWrap
            width: presentation.width
            horizontalAlignment: Text.Center
        }
    }

    function onActivate() {
        presentation.currentSlide = 0;
    }

    function onLeave() {
    }
}
