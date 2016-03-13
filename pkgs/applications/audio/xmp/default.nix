{ stdenv, fetchurl, pkgconfig, alsaLib, libxmp }:

stdenv.mkDerivation rec {
  name = "xmp-4.0.10";

  meta = with stdenv.lib; {
    description = "Extended module player";
    homepage    = "http://xmp.sourceforge.net/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/xmp/xmp/${name}.tar.gz";
    sha256 = "0gjylvvmq7ha0nhcjg56qfp0xxpsrcsj7y5r914svd5x1ppmzm5n";
  };

  buildInputs = [ pkgconfig alsaLib libxmp ];
}
