{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smplayer-0.8.5";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0vbfvaqg5c25vabq1mf9xg6kzgvxnpd0i172y1gjznnlpcw2fxrw";
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
