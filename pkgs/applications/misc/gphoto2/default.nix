{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "12zn677fvw1bmx70pg0vck2vrvkiy7hx1wzlwf6k23mhdnm4ipad";
  };

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ libgphoto2 libexif popt libjpeg readline libtool ];

  meta = {
    description = "a ready to use set of digital camera software applications";
    longDescription = ''

      A set of command line utilities for manipulating over 1400 different
      digital cameras. Through libgphoto2, it supports PTP, MTP, and much more..

    '';
    homepage = http://www.gphoto.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}
