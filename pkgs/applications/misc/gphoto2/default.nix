{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.5.23";

  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "1laqwhxr0xhbykmp0dhd3j4rr2lhj5y228s31afnqxp700hhk1yz";
  };

  nativeBuildInputs = [ pkgconfig gettext libtool ];
  buildInputs = [ libgphoto2 libexif popt libjpeg readline ];

  meta = with stdenv.lib; {
    description = "A ready to use set of digital camera software applications";
    longDescription = ''

      A set of command line utilities for manipulating over 1400 different
      digital cameras. Through libgphoto2, it supports PTP, MTP, and much more..

    '';
    homepage = "http://www.gphoto.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.jcumming ];
  };
}
