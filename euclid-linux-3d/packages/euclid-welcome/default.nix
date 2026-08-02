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
from PyQt6.QtCore import Qt

class WelcomeWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Euclid Linux 3D Welcome")
        self.resize(600, 400)

        layout = QVBoxLayout()

        # Read OS Release
        os_name = "Euclid Linux 3D"
        try:
            with open("/etc/os-release") as f:
                for line in f:
                    if line.startswith("PRETTY_NAME="):
                        os_name = line.strip().split("=")[1].strip('"')
        except: pass

        # Get Desktop Session
        session = os.environ.get("XDG_CURRENT_DESKTOP", "Unknown Desktop")

        info_label = QLabel(f"<h1>Welcome to {os_name}</h1>"
                            f"<p>Active Session: <b>{session}</b></p>"
                            "<p>Euclid Linux 3D brings you modern 3D capabilities via Compiz Reloaded.</p>"
                            "<ul><li><b>Lumina+Compiz</b>: The flagship, lightweight desktop.</li>"
                            "<li><b>MATE+Compiz</b>: Traditional and stable.</li>"
                            "<li><b>Plasma+Compiz</b>: Highly experimental.</li></ul>")
        info_label.setWordWrap(True)
        layout.addWidget(info_label)

        btn_install = QPushButton("Install Euclid Linux 3D")
        btn_install.clicked.connect(lambda: subprocess.Popen(["calamares"]))
        layout.addWidget(btn_install)

        btn_settings = QPushButton("System Settings (ccsm)")
        btn_settings.clicked.connect(lambda: subprocess.Popen(["ccsm"]))
        layout.addWidget(btn_settings)

        btn_docs = QPushButton("Open Release Notes")
        btn_docs.clicked.connect(lambda: subprocess.Popen(["xdg-open", "https://github.com/euclidprojects/Euclid-Linux-3D/releases"]))
        layout.addWidget(btn_docs)

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
