{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkg-config
, leptonica, libpng, libtiff, icu, pango, opencl-headers, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    hash = "sha256-sV3w53ky13ESc0dGPutMGQ4TcmOeWJkvUwBPIyzSTc8=";
  };

  # leptonica 1.83 made internal structures private. using internal headers isn't
  # great, but tesseract4's days are numbered anyway
  postPatch = ''
    sed -i '/allheaders.h/a#include "pix_internal.h"' src/textord/devanagari_processing.cpp
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [
    leptonica
    libpng
    libtiff
    icu
    pango
    opencl-headers
  ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ viric erikarvstedt ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
