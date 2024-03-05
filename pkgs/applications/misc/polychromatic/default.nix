{ lib
, fetchFromGitHub
, bash
, glib
, gdk-pixbuf
, gettext
, imagemagick
, ninja
, meson
, sassc
, python3Packages
, gobject-introspection
, wrapGAppsHook
, libappindicator-gtk3
, libxcb
, qt5
, ibus
, usbutils
}:

python3Packages.buildPythonApplication rec {
  name = "polychromatic";
  version = "0.8.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "polychromatic";
    repo = "polychromatic";
    rev = "v${version}";
    sha256 = "sha256-ym2pcGUWM5zCUx/lYs+WECj+wbyBtWnx04W/NRXNKlw=";
  };

  postPatch = ''
    patchShebangs scripts
    substituteInPlace scripts/build-styles.sh \
      --replace '$(which sassc 2>/dev/null)' '${sassc}/bin/sassc' \
      --replace '$(which sass 2>/dev/null)' '${sassc}/bin/sass'
    substituteInPlace polychromatic/paths.py \
      --replace "/usr/share/polychromatic" "$out/share/polychromatic"
  '';

  preConfigure = ''
    scripts/build-styles.sh
  '';
  nativeBuildInputs = with python3Packages; [
    gettext
    gobject-introspection
    meson
    ninja
    sassc
    wrapGAppsHook
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    colorama
    colour
    openrazer
    pyqt5
    pyqtwebengine
    requests
    setproctitle
    libxcb
    openrazer-daemon
    libappindicator-gtk3
    ibus
    usbutils
  ];

  dontWrapGapps = true;
  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
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
