{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smplayer-14.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "04yzgmdj9hm9v7ln49zm2aa1r9mm9q12pym4bvfww7yzsvnx96j2";
  };

  patches = [ ./basegui.cpp.patch ];

  buildInputs = [ qt4 ];

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    description = "A complete front-end for MPlayer";
    homepage = "http://smplayer.sourceforge.net/";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
