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

    # gcc-13 compat fix, simulate this upstream patch:
    #   https://github.com/tesseract-ocr/tesseract/commit/17e795aaae7d40dbcb7d3365835c2f55ecc6355d.patch
    #   https://github.com/tesseract-ocr/tesseract/commit/c0db7b7e930322826e09981360e39fdbd16cc9b0.patch

    sed -i src/ccutil/helpers.h -e '1i #include <climits>'
    sed -i src/ccutil/helpers.h -e '1i #include <cstdint>'
    sed -i src/dict/matchdefs.h -e '1i #include <cstdint>'
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
