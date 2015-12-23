{ stdenv, fetchurl, qtscript }:

stdenv.mkDerivation rec {
  name = "smplayer-15.11.0";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1h8r5xjaq7p78raw1v29gsrcv221lzl8m2i2qls3khc65kx032cn";
  };

  patches = [ ./basegui.cpp.patch ];

  buildInputs = [ qtscript ];

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
