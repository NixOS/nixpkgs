{ stdenv, fetchurl, zlib, glib, xorg, dbus, fontconfig,
  freetype, xkeyboard_config, makeDesktopItem, makeWrapper }:

stdenv.mkDerivation rec {
  name = "robo3t-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "https://download.robomongo.org/1.1.1/linux/robo3t-${version}-linux-x86_64-c93c6b0.tar.gz";
    sha256 = "140cn80vg7c8vpdjasqi4b3kyqj4n033lcm3ikz5674x3jr7r5zs";
  };

  icon = fetchurl {
    url = "https://github.com/Studio3T/robomongo/raw/${version}/trash/install/linux/robomongo.png";
    sha256 = "15li8536x600kkfkb3h6mw7y0f2ljkv951pc45dpiw036vldibv2";
  };

  desktopItem = makeDesktopItem {
    name = "robo3t";
    exec = "robo3t";
    icon = icon;
    comment = "Query GUI for mongodb";
    desktopName = "Robo3T";
    genericName = "MongoDB management tool";
    categories = "Development;IDE;mongodb;";
  };

  nativeBuildInputs = [makeWrapper];

  ldLibraryPath = stdenv.lib.makeLibraryPath [
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
  ];

  installPhase = ''
    BASEDIR=$out/lib/robo3t

    mkdir -p $BASEDIR/bin
    cp bin/* $BASEDIR/bin

    mkdir -p $BASEDIR/lib
    cp -r lib/* $BASEDIR/lib

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications

    mkdir -p $out/share/icons
    cp ${icon} $out/share/icons/robomongo.png

    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $BASEDIR/bin/robo3t

    mkdir $out/bin

    makeWrapper $BASEDIR/bin/robo3t $out/bin/robo3t \
      --suffix LD_LIBRARY_PATH : ${ldLibraryPath} \
      --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb
  '';

  meta = {
    homepage = https://robomongo.org/;
    description = "Query GUI for mongodb";
    platforms = stdenv.lib.intersectLists stdenv.lib.platforms.linux stdenv.lib.platforms.x86_64;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.eperuffo ];
  };
}
