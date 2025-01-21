{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
  libpng,
  libxml2,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "flam3";
  version = "3.1.1+date=2018-04-12";

  src = fetchFromGitHub {
    owner = "scottdraves";
    repo = pname;
    rev = "7fb50c82e90e051f00efcc3123d0e06de26594b2";
    hash = "sha256-cKRfmTcyWY2LyxqojTzxD2wnxu5eh3emHi51bhS3gYg=";
  };

  buildInputs = [
    libjpeg
    libpng
    libxml2
    zlib
  ];

  meta = with lib; {
    homepage = "https://flam3.com/";
    description = "Cosmic recursive fractal flames";
    longDescription = ''
      Flames are algorithmically generated images and animations. The software
      was originally written in 1992 and released as open source, aka free
      software. Over the years it has been greatly expanded, and is now widely
      used to create art and special effects. The shape and color of each image
      is specified by a long string of numbers - a genetic code of sorts.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
