{ lib
, fetchFromGitHub
, bash
, cairo
, glib
, qt5
, hicolor-icon-theme
, gdk-pixbuf
, imagemagick
, desktop-file-utils
, ninja
, meson
, sassc
, ibus
, usbutils
, xorg
, python3Packages
, gobject-introspection
, gtk3
, wrapGAppsHook
, libappindicator-gtk3
}:

python3Packages.buildPythonApplication rec {
  name = "polychromatic";
  version = "0.7.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    rev = "v${version}";
    sha256 = "109p89d56qp0pybhrwx9n7xzj5jg74pihh4ic5c6nzjbyjkc9xjn";
  };

  postPatch = ''
    patchShebangs scripts
    
    substituteInPlace scripts/build-styles.sh \
      --replace '$(which sassc 2>/dev/null)' '${sassc}/bin/sassc' \
      --replace '$(which sass 2>/dev/null)' '${sassc}/bin/sass'

    substituteInPlace pylib/common.py --replace "/usr/share/polychromatic" "$out/share/polychromatic"

    scripts/build-styles.sh
  '';

  buildInputs = [
    cairo
    hicolor-icon-theme
  ];

  pythonPath = with python3Packages; [
    openrazer
    pyqt5
    pyqtwebengine
  ];

  propagatedBuildInputs = with python3Packages; [
    xorg.libxcb
    colour
    colorama
    setproctitle
    openrazer
    openrazer-daemon
    requests
    ibus
    usbutils
    pyqt5
    libappindicator-gtk3
  ];

  nativePropagatedBuildInputs = [
    gobject-introspection
    gtk3
    gdk-pixbuf
    imagemagick
  ];

  nativeBuildInputs = with python3Packages; [
    pyqt5
    desktop-file-utils
    qt5.wrapQtAppsHook
    wrapGAppsHook
    ninja
    meson
    sassc
  ];

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://polychromatic.app/";
    description = "Graphical front-end and tray applet for configuring Razer peripherals on GNU/Linux.";
    longDescription = ''
      Polychromatic is a frontend for OpenRazer that enables Razer devices
      to control lighting effects and more on GNU/Linux.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ evanjs ];
  };
}
