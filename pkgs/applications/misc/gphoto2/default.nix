{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.5.17";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "0kslwclyyzvnxjw3gdzhlagj7l5f8lba833ipr9s0s0c4hwi0mxa";
  };

  nativeBuildInputs = [ pkgconfig gettext libtool ];
  buildInputs = [ libgphoto2 libexif popt libjpeg readline ];

  meta = with stdenv.lib; {
    description = "A ready to use set of digital camera software applications";
    longDescription = ''

      A set of command line utilities for manipulating over 1400 different
      digital cameras. Through libgphoto2, it supports PTP, MTP, and much more..

    '';
    homepage = http://www.gphoto.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.jcumming ];
  };
}
