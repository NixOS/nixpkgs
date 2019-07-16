{ stdenv, fetchFromGitHub
, makeWrapper, makeDesktopItem
, qtbase, qmake, qtmultimedia, qttools
, qtgraphicaleffects, qtdeclarative
, qtlocation, qtquickcontrols, qtquickcontrols2
, qtwebchannel, qtwebengine, qtx11extras, qtxmlpatterns
, monero, unbound, readline, boost, libunwind
, libsodium, pcsclite, zeromq, cppzmq, pkgconfig
, hidapi
}:

with stdenv.lib;

let
  qmlPath = qmlLib: "${qmlLib}/${qtbase.qtQmlPrefix}";

  qml2ImportPath = concatMapStringsSep ":" qmlPath [
    qtbase.bin qtmultimedia.bin qtgraphicaleffects
    qtdeclarative.bin qtlocation.bin
    qtquickcontrols qtquickcontrols2.bin
    qtwebchannel.bin qtwebengine.bin qtxmlpatterns
  ];

in

stdenv.mkDerivation rec {
  name = "monero-gui-${version}";
  version = "0.14.1.0";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero-gui";
    rev    = "v${version}";
    sha256 = "0ilx47771faygf97wilm64xnqxgxa3b43q0g9v014npk0qj8pc31";
  };

  nativeBuildInputs = [ qmake pkgconfig ];

  buildInputs = [
    qtbase qtmultimedia qtgraphicaleffects
    qtdeclarative qtlocation
    qtquickcontrols qtquickcontrols2
    qtwebchannel qtwebengine qtx11extras
    qtxmlpatterns monero unbound readline
    boost libunwind libsodium pcsclite zeromq
    cppzmq makeWrapper hidapi
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
    desktopName = "Monero";
    genericName = "Wallet";
    categories  = "Application;Network;Utility;";
  };

  postInstall = ''
    # install desktop entry
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    # install translations
    mkdir -p $out/share/translations
    cp translations/*.qm $out/share/translations/

    # install icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/images/appicons/$size.png \
         $out/share/icons/hicolor/$size/apps/monero.png
    done;

    # wrap runtime dependencies
    wrapProgram $out/bin/monero-wallet-gui \
      --set QML2_IMPORT_PATH "${qml2ImportPath}" \
      --set QT_PLUGIN_PATH "${qtbase.bin}/${qtbase.qtPluginPrefix}"
  '';

  meta = {
    description = "Private, secure, untraceable currency";
    homepage    = https://getmonero.org/;
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
