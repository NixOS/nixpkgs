{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "16c8k1cxfypg7v5h8xi87grclw7a5ayaamn548ys3zkj727r5fcf";
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
