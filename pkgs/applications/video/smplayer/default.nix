{ stdenv, fetchurl, qmake, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-18.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0y7kwcngd0d2d863wnppfvjm1n1l60nn6lsf9r0g4hsf19gkrd46";
  };

  buildInputs = [ qtscript ];
  nativeBuildInputs = [ qmake ];

  dontUseQmakeConfigure = true;

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A complete front-end for MPlayer";
    homepage = http://smplayer.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
