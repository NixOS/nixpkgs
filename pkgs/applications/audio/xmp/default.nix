{ stdenv, fetchurl, pkgconfig, alsaLib, libxmp }:

stdenv.mkDerivation rec {
  name = "xmp-4.1.0";

  meta = with stdenv.lib; {
    description = "Extended module player";
    homepage    = "http://xmp.sourceforge.net/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/xmp/xmp/${name}.tar.gz";
    sha256 = "17i8fc7x7yn3z1x963xp9iv108gxfakxmdgmpv3mlm438w3n3g8x";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib libxmp ];
}
