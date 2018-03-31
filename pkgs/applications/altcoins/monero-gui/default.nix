{ stdenv, fetchFromGitHub
, makeWrapper, makeDesktopItem
, qtbase, qmake, qtmultimedia, qttools
, qtgraphicaleffects, qtdeclarative
, qtlocation, qtquickcontrols2, qtwebchannel
, qtwebengine, qtx11extras, qtxmlpatterns
, monero, unbound, readline, boost, libunwind
, pcsclite, zeromq, cppzmq, pkgconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "monero-gui-${version}";
  version = "2018-03-31";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero-gui";
    rev    = "fbe5ba831795008361f4de4347e7ecb6d868b4eb";
    sha256 = "06cncwk4mxfw1rqwlwisasvangl73xyqwj4g6r9j85j5x4xy0k5s";
  };

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [
    qtbase qtmultimedia qtgraphicaleffects
    qtdeclarative qtlocation qtquickcontrols2
    qtwebchannel qtwebengine qtx11extras
    qtxmlpatterns monero unbound readline
    boost libunwind pcsclite zeromq cppzmq
    makeWrapper
  ];

  patches = [
    ./move-log-file.patch
    ./move-translations-dir.patch
  ];

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
    desktopName = "Monero Wallet";
    genericName = "Wallet";
    categories  = "Application;Network;Utility;";
  };

  postInstall = ''
    # install desktop entry
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    # install translations
    cp -r release/bin/translations $out/share/

    # install icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/images/appicons/$size.png \
         $out/share/icons/hicolor/$size/apps/monero.png
    done;
  '';

  meta = {
    description = "Private, secure, untraceable currency";
    homepage    = https://getmonero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
