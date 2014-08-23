{ stdenv, fetchurl, pkgconfig, alsaLib, libxmp }:

stdenv.mkDerivation rec {
  name = "xmp-4.0.7";

  meta = with stdenv.lib; {
    description = "Extended module player";
    homepage    = "http://xmp.sourceforge.net/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "mirror://sourceforge/xmp/xmp/${name}.tar.gz";
    sha256 = "0qgzzaxhshz5l7s21x89xb43pbbi0zap6a4lk4s7gjp1qca2agcw";
  };

  buildInputs = [ pkgconfig alsaLib libxmp ];
}
