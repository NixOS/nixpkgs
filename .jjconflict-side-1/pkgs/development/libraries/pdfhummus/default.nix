{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  zlib,
  freetype,
  libjpeg,
  libtiff,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "pdfhummus";
  version = "4.6.7";

  src = fetchFromGitHub {
    owner = "galkahana";
    repo = "PDF-Writer";
    rev = "v${version}";
    hash = "sha256-XOoMh1YL4wJQ6Uliy0sdcrlqJbbbnZ0gmjuaXS1h+qQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qtbase
  ];

  propagatedBuildInputs = [
    zlib
    freetype
    libjpeg
    libtiff
    libpng
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_BUNDLED=OFF"
    # Use bundled LibAesgm
    "-DUSE_UNBUNDLED_FALLBACK_BUNDLED=ON"
  ];

  meta = with lib; {
    description = "Fast and Free C++ Library for Creating, Parsing an Manipulating PDF Files and Streams";
    homepage = "https://www.pdfhummus.com";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
