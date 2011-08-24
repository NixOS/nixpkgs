{stdenv, fetchurl, libX11, libXinerama}:

stdenv.mkDerivation rec {
  name = "dmenu-4.4";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "016hfnmk4kb2n3slxrg4z27p2l8x1awqsig961syssw4p1zybpav";
  };

  buildInputs = [ libX11 libXinerama ];

  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];

  meta = { 
      description = "a generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://tools.suckless.org/dmenu;
      license = "MIT";
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; all;
  };
}
