import io.calamares.core

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Page {
    width: parent.width
    height: parent.height

    ColumnLayout {
        width: parent.width
        spacing: Kirigami.Units.smallSpacing

        Column {
            Layout.fillWidth: true

            Text {
                text: qsTr("NixOS is fully open source, but it also provides optional software packages that do not respect users' freedom to run, copy, distribute, study, change and improve the software, and are commonly not open source. By default such \"unfree\" packages are not allowed, but you can enable it here. If you check this box, you agree that unfree software may be installed which might have additional End User License Agreements (EULAs) that you need to agree to. If not enabled, some hardware (notably Nvidia GPUs and some WiFi chips) might not work or not work optimally.<br/>")
                width: parent.width
                wrapMode: Text.WordWrap
            }

            CheckBox {
                text: qsTr("Allow unfree software")

                onCheckedChanged: {
                    Global.insert("nixos_allow_unfree", checked)
                }
            }
        }
    }
}
