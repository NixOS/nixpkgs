{ stdenv, fetchurl, which, qt3, x11
, libXinerama, libXv, libXxf86vm, libXrandr, libXmu
, lame, zlib, mesa}:

assert qt3.mysqlSupport;

stdenv.mkDerivation {
  name = "mythtv-0.20";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.osuosl.org/pub/mythtv/mythtv-0.20.tar.bz2;
    md5 = "52bec1e0fadf7d24d6dcac3f773ddf74";
  };

  patches = [./settings.patch];
  configureFlags = "--disable-joystick-menu";

  buildInputs = [
    which qt3 x11 libXinerama libXv libXxf86vm libXrandr libXmu
    lame zlib mesa
  ];
  
  inherit qt3;
}
