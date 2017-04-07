{ stdenv, fetchurl, zlib, glib, xorg, dbus, fontconfig, freetype, xkeyboard_config, makeWrapper }:

stdenv.mkDerivation {
  name = "robomongo-0.9.0";

  src = fetchurl {
    url = "https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz";
    sha256 = "1q8ahdz3afcw002p8dl2pybzkq4srk6bnikrz216yx1gswivdcad";
  };

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

  buildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin

    mkdir -p $out/lib
    cp -r lib/* $out/lib

    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/bin/robomongo

    wrapProgram $out/bin/robomongo \
      --suffix LD_LIBRARY_PATH : $ldLibraryPath \
      --suffix QT_XKB_CONFIG_ROOT : ${xkeyboard_config}/share/X11/xkb
  '';

  meta = {
    homepage = "https://robomongo.org/";
    description = "Query GUI for mongodb";
    platforms = stdenv.lib.intersectLists stdenv.lib.platforms.linux stdenv.lib.platforms.x86_64;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.eperuffo ];
  };
}
