{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.5.8";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "0kgfql6c64ha1gahjdwlqhmkslnfywmc2fkys4c5682zv4awvax9";
  };

  nativeBuildInputs = [ pkgconfig gettext ];
  buildInputs = [ libgphoto2 libexif popt libjpeg readline libtool ];

  meta = {
    description = "A ready to use set of digital camera software applications";
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
