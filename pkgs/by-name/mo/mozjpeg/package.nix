{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libpng,
  zlib,
  nasm,
}:

stdenv.mkDerivation rec {
  version = "4.1.5";
  pname = "mozjpeg";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "mozjpeg";
    rev = "v${version}";
    sha256 = "sha256-k8qWtU4j3ipIHvY60ae7kdNnPvWnUa0qgacqlSIJijo=";
  };

  cmakeFlags = [
    "-DENABLE_STATIC=NO"
    "-DPNG_SUPPORTED=TRUE"
  ]; # See https://github.com/mozilla/mozjpeg/issues/351

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libpng
    zlib
    nasm
  ];

  meta = {
    description = "Mozilla JPEG Encoder Project";
    longDescription = ''
      This project's goal is to reduce the size of JPEG files without reducing quality or compatibility with the
      vast majority of the world's deployed decoders.

      The idea is to reduce transfer times for JPEGs on the Web, thus reducing page load times.
    '';
    homepage = "https://github.com/mozilla/mozjpeg";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.aristid ];
    platforms = lib.platforms.all;
  };
}
