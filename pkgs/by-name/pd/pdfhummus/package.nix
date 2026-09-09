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
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "galkahana";
    repo = "PDF-Writer";
    rev = "v${version}";
    hash = "sha256-CUxgJsY9/KzshrMyRPP2SFwQUtjBThW9qg/IkQkjcwk=";
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
