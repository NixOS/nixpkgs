{stdenv, fetchurl, libX11, libXinerama}:

stdenv.mkDerivation rec {
  name = "dmenu-4.4.1";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0l25vdnzlslk0r4m6hjkzxdygh3wpq04b9mr8zc9h3b1md2icr3d";
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
