{ lib
, stdenv
, fetchurl
, curl
, zlib
, glib
, xorg
, dbus
, fontconfig
, libGL
, freetype
, xkeyboard_config
, makeDesktopItem
, makeWrapper
}:

let
  curlWithGnuTls = curl.override { gnutlsSupport = true; opensslSupport = false; };
in

stdenv.mkDerivation rec {
  pname = "robo3t";
  version = "1.4.3";
  rev = "48f7dfd";

  src = fetchurl {
    url = "https://github.com/Studio3T/robomongo/releases/download/v${version}/robo3t-${version}-linux-x86_64-${rev}.tar.gz";
    sha256 = "sha256-pH4q/O3bq45ZZn+s/12iScd0WbfkcLjK4MBdVCMXK00=";
  };

  icon = fetchurl {
    url = "https://github.com/Studio3T/robomongo/raw/${rev}/install/macosx/robomongo.iconset/icon_128x128.png";
    sha256 = "sha256-2PkUxBq2ow0wl09k8B6LJJUQ+y4GpnmoAeumKN1u5xg=";
  };

  desktopItem = makeDesktopItem {
    name = "robo3t";
    exec = "robo3t";
    icon = icon;
    comment = "Query GUI for mongodb";
    desktopName = "Robo3T";
    genericName = "MongoDB management tool";
    categories = [ "Development" "IDE" ];
  };

  nativeBuildInputs = [ makeWrapper ];

  ldLibraryPath = lib.makeLibraryPath [
    stdenv.cc.cc
    zlib
    glib
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libXext
    dbus
    fontconfig
    freetype
    libGL
    curlWithGnuTls
  ];

  installPhase = ''
    runHook preInstall

    BASEDIR=$out/lib/robo3t

    mkdir -p $BASEDIR/bin
    cp bin/* $BASEDIR/bin

    mkdir -p $BASEDIR/lib
    cp -r lib/* $BASEDIR/lib

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications

    mkdir -p $out/share/icons
    cp ${icon} $out/share/icons/robomongo.png

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $BASEDIR/bin/robo3t

    mkdir $out/bin

    makeWrapper $BASEDIR/bin/robo3t $out/bin/robo3t \
      --suffix LD_LIBRARY_PATH : ${ldLibraryPath} \
      --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://robomongo.org/";
    description = "Query GUI for mongodb. Formerly called Robomongo";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ eperuffo ];
  };
}
