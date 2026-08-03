{ lib, python3Packages, qt6, makeWrapper }:

python3Packages.buildPythonApplication {
  pname = "euclid-welcome";
  version = "1.0";
  format = "other";
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper qt6.wrapQtAppsHook qt6.qtbase ];
  propagatedBuildInputs = [ python3Packages.pyqt6 ];

  installPhase = ''
    mkdir -p $out/bin
    cat << 'PY' > $out/bin/euclid-welcome
#!/usr/bin/env python
import sys, os, subprocess
from PyQt6.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QLabel, QPushButton, QWidget

class WelcomeWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Euclid Linux 3D Welcome")
        self.resize(600, 500)

        layout = QVBoxLayout()

        os_name = "Euclid Linux 3D Budgie+Compiz"
        try:
            with open("/etc/os-release") as f:
                for line in f:
                    if line.startswith("PRETTY_NAME="):
                        os_name = line.strip().split("=")[1].strip('"')
        except: pass

        session = os.environ.get("XDG_CURRENT_DESKTOP", "Unknown Desktop")

        info_label = QLabel(f"<h1>Welcome to {os_name}</h1>"
                            f"<p>Active Session: <b>{session}</b></p>"
                            "<p>Euclid Linux 3D brings you modern 3D capabilities via Compiz Reloaded.</p>")
        info_label.setWordWrap(True)
        layout.addWidget(info_label)

        def add_button(text, cmd):
            btn = QPushButton(text)
            btn.clicked.connect(lambda: subprocess.Popen(cmd))
            layout.addWidget(btn)

        add_button("Install Euclid Linux 3D", ["calamares"])
        add_button("Open Budgie Desktop Settings", ["budgie-desktop-settings"])
        add_button("Open CompizConfig Settings Manager", ["ccsm"])
        add_button("Hardware Information", ["sysinfo"])
        add_button("Update the system", ["gnome-terminal", "-e", "sudo nixos-rebuild switch"])
        add_button("Open Release Notes", ["xdg-open", "https://github.com/euclidprojects/Euclid-Linux-3D/releases"])

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    win = WelcomeWindow()
    win.show()
    sys.exit(app.exec())
PY
    chmod +x $out/bin/euclid-welcome

    mkdir -p $out/share/applications
    cat << 'DESKTOP' > $out/share/applications/euclid-welcome.desktop
[Desktop Entry]
Name=Euclid Welcome
Comment=Welcome to Euclid Linux 3D
Exec=euclid-welcome
Icon=euclid-welcome
Terminal=false
Type=Application
Categories=Utility;System;
DESKTOP
  '';

  postFixup = ''
    wrapQtApp $out/bin/euclid-welcome
  '';

  meta = {
    description = "Euclid Linux 3D Welcome Application";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
