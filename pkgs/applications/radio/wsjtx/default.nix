{
  lib,
  stdenv,
  fetchgit,
  asciidoc,
  asciidoctor,
  cmake,
  pkg-config,
  fftw,
  fftwFloat,
  gfortran,
  hamlib_4,
  libtool,
  libusb1,
  qtbase,
  qtmultimedia,
  qtserialport,
  qttools,
  boost,
  texinfo,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "wsjtx";
  version = "2.7.0";

  src = fetchgit {
    url = "http://git.code.sf.net/p/wsjt/wsjtx";
    rev = "wsjtx-${version}";
    hash = "sha256-AAPZTJUhz3x/28B9rk2uwFs1bkcEvaj+hOzAjpsFALQ=";
  };

  nativeBuildInputs = [
    asciidoc
    asciidoctor
    cmake
    gfortran
    hamlib_4 # rigctl
    libtool
    pkg-config
    qttools
    texinfo
    wrapQtAppsHook
  ];
  buildInputs = [
    fftw
    fftwFloat
    hamlib_4
    libusb1
    qtbase
    qtmultimedia
    qtserialport
    boost
  ];

  strictDeps = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Weak-signal digital communication modes for amateur radio";
    longDescription = ''
      WSJT-X implements communication protocols or "modes" called FT4, FT8, JT4,
      JT9, JT65, QRA64, ISCAT, MSK144, and WSPR, as well as one called Echo for
      detecting and measuring your own radio signals reflected from the Moon.
      These modes were all designed for making reliable, confirmed ham radio
      contacts under extreme weak-signal conditions.
    '';
    homepage = "https://wsjt.sourceforge.io";
<<<<<<< HEAD
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lasandell
      numinit
=======
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [
      lasandell
      numinit
      melling
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
