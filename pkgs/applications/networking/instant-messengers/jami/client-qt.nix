{ version
, src
, jami-meta
, lib
, stdenv
, pkg-config
, cmake
, networkmanager # for libnm
, python3
, qttools # for translations
, wrapQtAppsHook
, libnotify
, qt5compat
, qtbase
, qtdeclarative
, qrencode
, qtmultimedia
, qtnetworkauth
, qtsvg
, qtwebengine
, qtwebchannel
, jami-libclient
}:

stdenv.mkDerivation {
  pname = "jami-client-qt";
  inherit version src;

  sourceRoot = "source/client-qt";

  preConfigure = ''
    python gen-resources.py
    echo 'const char VERSION_STRING[] = "${version}";' > src/version.h
  '';

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    cmake
    python3
    qttools
  ];

  buildInputs = [
    jami-libclient
    networkmanager
    libnotify
    qtbase
    qt5compat
    qrencode
    qtnetworkauth
    qtdeclarative
    qtmultimedia
    qtsvg
    qtwebchannel
    qtwebengine
  ];

  qtWrapperArgs = [
    # With wayland the titlebar is not themed and the wmclass is wrong.
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  meta = jami-meta // {
    description = "The client based on QT" + jami-meta.description;
  };
}
