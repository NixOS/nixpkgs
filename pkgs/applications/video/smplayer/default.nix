{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smplayer-14.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "9b8db20043d1528ee5c6054526779e88a172d2c757429bd7095c794d65ecbc18";
  };

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
