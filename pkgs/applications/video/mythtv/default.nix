a@{ stdenv, fetchurl, which, qt3, x11, xlibs
, lame, zlib, mesa, alsaLib
, freetype, perl
}:

let
  qt3 = a.qt3.override { mysqlSupport = true; };
in

stdenv.mkDerivation {
  name = "mythtv-0.21";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://ftp.osuosl.org/pub/mythtv/mythtv-0.21.tar.bz2;
    sha256 = "1r654fvklpsf6h9iqckb8fhd7abgs71lx6xh352xgz9yzjl7ia1k";
  };

  #configureFlags = "--x11-path=/no-such-path --dvb-path=/no-such-path";

  configureFlags = ''
    --disable-joystick-menu --disable-dvb
  '';

  buildInputs = [
    freetype qt3 lame zlib x11 mesa perl alsaLib
    xlibs.libX11 xlibs.libXv xlibs.libXrandr xlibs.libXvMC xlibs.libXmu
    xlibs.libXinerama xlibs.libXxf86vm xlibs.libXmu
  ];
  
  patches = [
    ./settings.patch
    ./purity.patch # don't search in /usr/include etc.
  ];
}
