{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  zlib,
  freetype,
  libjpeg,
  libtiff,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "pdfhummus";
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "galkahana";
    repo = "PDF-Writer";
    rev = "v${version}";
    hash = "sha256-3A5KyY1w5FKsa4CMOOrwoadMjbIShH8MzntDE1asCqs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libsForQt5.qtbase
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

  meta = {
    description = "Fast and Free C++ Library for Creating, Parsing an Manipulating PDF Files and Streams";
    homepage = "https://www.pdfhummus.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wineee ];
  };
}
