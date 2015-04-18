{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smplayer-14.9.0.6690";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0nmw69kg8rqvl9icyx1r1v1pyxg6560363l0kyqyja18j79a3j2y";
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
