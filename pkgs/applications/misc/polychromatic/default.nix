{ lib
, fetchFromGitHub
, bash
, cairo
, glib
, pkgconfig
, qt5
, buildPythonApplication
, hicolor-icon-theme
, gdk-pixbuf
, imagemagick
, desktop-file-utils
, ninja
, meson
, sass
, sassc
, ibus
, usbutils
, xorg
, pythonPackages
, gobject-introspection
, gtk3
, wrapGAppsHook
}:

  buildPythonApplication rec {
    name = "polychromatic-${version}";
    version = "0.7.0";

    format = "other";

    src = fetchFromGitHub {
      owner = "polychromatic";
      repo = "polychromatic";
      rev = "v${version}";
      sha256 = "0sb0h90v9k0z5321zprdxqh5mmvx39avapj7m09xxlq3qacc17qh";
    };

    postPatch = ''
      patchShebangs scripts
    '';


    buildInputs = [
      cairo
      hicolor-icon-theme
    ];

    pythonPath = with pythonPackages; [
      openrazer
      pyqt5
      pyqtwebengine
    ];

    propagatedBuildInputs = with pythonPackages; [
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
    ];

    nativePropagatedBuildInputs = [
      gobject-introspection
      gtk3
      gdk-pixbuf
      imagemagick
    ];

    nativeBuildInputs = with pythonPackages; [
      pyqt5
      desktop-file-utils
      qt5.wrapQtAppsHook
      wrapGAppsHook
      sass
      sassc
      ninja
      meson
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
