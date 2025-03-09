{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gettext,
  libexif,
  libgphoto2,
  libjpeg,
  libtool,
  popt,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "gphoto2";
  version = "2.5.28";

  src = fetchFromGitHub {
    owner = "gphoto";
    repo = "gphoto2";
    rev = "v${version}";
    sha256 = "sha256-t5EnM4WaDbOTPM+rJW+hQxBgNErnnZEN9lZvxTKoDhA=";
  };

  patches = [ ./add-type-casts.diff ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
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
    description = "Ready to use set of digital camera software applications";
    longDescription = ''

      A set of command line utilities for manipulating over 1400 different
      digital cameras. Through libgphoto2, it supports PTP, MTP, and much more..

    '';
    homepage = "http://www.gphoto.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.jcumming ];
    mainProgram = "gphoto2";
  };
}
