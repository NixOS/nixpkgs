{stdenv, fetchurl, libX11, libXinerama}:

stdenv.mkDerivation rec {
  name = "dmenu-4.0";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0qp8n9hz15lzqp5dnq6lqknxhmlrgv20x2bnbc2zr891bql0hif0";
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
