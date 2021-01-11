{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, gettext
, libexif
, libgphoto2
, libjpeg
, libtool
, popt
, readline
}:

stdenv.mkDerivation rec {
  pname = "gphoto2";
  version = "2.5.26";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "gphoto2";
    rev = "v${version}";
    sha256 = "1w01j3qvjl2nlfs38rnsmjvn3r0r2xf7prxz1i6yarbpj3fzwqqc";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    gettext
    libtool
  ];

  buildInputs = [
    libexif
    libgphoto2
    libjpeg
    popt
    readline
  ];

  meta = with lib; {
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
