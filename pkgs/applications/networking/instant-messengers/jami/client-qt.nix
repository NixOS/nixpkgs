{ version
, src
, jami-meta
, mkDerivation
, lib
, pkg-config
, cmake
, networkmanager # for libnm
, python3
, qttools # for translations
, wrapQtAppsHook
, libnotify
, qrencode
, qtwebengine
, qtdeclarative
, qtquickcontrols2
, qtmultimedia
, qtsvg
, qtwebchannel
, qtgraphicaleffects # no gui without this
, jami-libclient
}:

mkDerivation {
  pname = "jami-client-qt";
  inherit version src;

  sourceRoot = "source/client-qt";

  preConfigure = ''
    python gen-resources.py
    echo 'const char VERSION_STRING[] = "${version}";' > src/version.h
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
    qttools
  ];

  buildInputs = [
    jami-libclient
    networkmanager
    libnotify
    qrencode
    qtwebengine
    qtdeclarative
    qtquickcontrols2
    qtmultimedia
    qtsvg
    qtwebchannel
    qtgraphicaleffects
  ];

  meta = jami-meta // {
    description = "The client based on QT" + jami-meta.description;
  };
}
