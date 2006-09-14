{ stdenv, fetchurl, which, qt3, x11
, libX11, libXinerama, libXv, libXxf86vm, libXrandr, libXmu
, lame, zlib, mesa}:

assert qt3.mysqlSupport;

stdenv.mkDerivation {
  name = "mythtv-0.20";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.osuosl.org/pub/mythtv/mythtv-0.20.tar.bz2;
    md5 = "52bec1e0fadf7d24d6dcac3f773ddf74";
  };

  configureFlags = "--disable-joystick-menu --x11-path=/no-such-path --dvb-path=/no-such-path";

  buildInputs = [
    which qt3 x11
    libX11 libXinerama libXv libXxf86vm libXrandr libXmu
    lame zlib mesa
  ];
  
  patches = [
    ./settings.patch
    ./purity.patch # don't search in /usr/include etc.
  ];
}
