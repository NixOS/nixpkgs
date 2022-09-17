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
, libxcb
, python3Packages
, gobject-introspection
, gtk3
, wrapGAppsHook
, libappindicator-gtk3
}:

python3Packages.buildPythonApplication rec {
  name = "polychromatic";
  version = "0.7.3";

  format = "other";

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    rev = "v${version}";
    sha256 = "sha256-H++kQ3Fxw56avEsSE1ctu5p0s50s0eQ+jL5zXS3AA94=";
  };

  postPatch = ''
    patchShebangs scripts

    substituteInPlace scripts/build-styles.sh \
      --replace '$(which sassc 2>/dev/null)' '${sassc}/bin/sassc' \
      --replace '$(which sass 2>/dev/null)' '${sassc}/bin/sass'

    substituteInPlace pylib/common.py --replace "/usr/share/polychromatic" "$out/share/polychromatic"
  '';

  preConfigure = ''
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
    libxcb
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

  nativeBuildInputs = with python3Packages; [
    pyqt5
    desktop-file-utils
    qt5.wrapQtAppsHook
    wrapGAppsHook
    ninja
    meson
    sassc
  ];

  propagatedNativeBuildInputs = [
    gobject-introspection
    gtk3
    gdk-pixbuf
    imagemagick
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
