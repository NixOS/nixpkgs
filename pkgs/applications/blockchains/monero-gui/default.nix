{ mkDerivation, lib, makeDesktopItem, fetchFromGitHub
, qtbase, qmake, qtmultimedia, qttools
, qtgraphicaleffects, qtdeclarative
, qtlocation, qtquickcontrols, qtquickcontrols2
, qtwebchannel, qtwebengine, qtx11extras, qtxmlpatterns
, monero, unbound, readline, boost, libunwind
, libsodium, pcsclite, zeromq, cppzmq, pkgconfig
, hidapi
}:

with lib;

mkDerivation rec {
  pname = "monero-gui";
  version = "0.14.1.2";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero-gui";
    rev    = "v${version}";
    sha256 = "1rm043r6y2mzy8pclnzbjjfxgps8pkfa2b92p66k8y8rdmgq6m1k";
  };

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [
    qtbase qtmultimedia qtgraphicaleffects
    qtdeclarative qtlocation
    qtquickcontrols qtquickcontrols2
    qtwebchannel qtwebengine qtx11extras
    qtxmlpatterns monero unbound readline
    boost libunwind libsodium pcsclite zeromq
    cppzmq hidapi
  ];

  patches = [ ./move-log-file.patch ];

  postPatch = ''
    echo '
      var GUI_VERSION = "${version}";
      var GUI_MONERO_VERSION = "${getVersion monero}";
    ' > version.js
    substituteInPlace monero-wallet-gui.pro \
      --replace '$$[QT_INSTALL_BINS]/lrelease' '${getDev qttools}/bin/lrelease'
    substituteInPlace src/daemon/DaemonManager.cpp \
      --replace 'QApplication::applicationDirPath() + "' '"${monero}/bin'
  '';

  makeFlags = [ "INSTALL_ROOT=$(out)" ];

  preBuild = ''
    sed -i s#/opt/monero-wallet-gui##g Makefile
    make -C src/zxcvbn-c
  '';

  desktopItem = makeDesktopItem {
    name = "monero-wallet-gui";
    exec = "monero-wallet-gui";
    icon = "monero";
    desktopName = "Monero";
    genericName = "Wallet";
    categories  = "Application;Network;Utility;";
  };

  postInstall = ''
    # install desktop entry
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    # install icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/images/appicons/$size.png \
         $out/share/icons/hicolor/$size/apps/monero.png
    done;
  '';

  meta = {
    description  = "Private, secure, untraceable currency";
    homepage     = https://getmonero.org/;
    license      = licenses.bsd3;
    platforms    = platforms.all;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
