{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.4.11";
  
  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "0ah42b7rnqh0z8bb96z7cdycxdh5k19h6lmfc02kdhrhqdr3q81y";
  };
  
  buildNativeInputs = [ pkgconfig gettext ];
  buildInputs = [ libgphoto2 libexif popt libjpeg readline libtool ];
  
  meta = {
    homepage = http://www.gphoto.org/;
  };
}
