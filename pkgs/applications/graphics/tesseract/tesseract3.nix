{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  leptonica,
  libpng,
  libtiff,
  icu,
  pango,
  opencl-headers,
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "3.05.02";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    hash = "sha256-28osuZnVwkJpNTYkU+5D5PI8xtViFzGCMScHzkS2H20=";
  };

  # leptonica 1.83 made internal structures private. using internal headers isn't
  # great, but tesseract3's days are numbered anyway
  postPatch = ''
    for f in textord/devanagari_processing.cpp cube/cube_line_object.h cube/cube_line_segmenter.h cube/cube_utils.h ; do
      sed -i '/allheaders.h/a#include "pix_internal.h"' "$f"
    done
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    leptonica
    libpng
    libtiff
    icu
    pango
    opencl-headers
  ];

  LIBLEPT_HEADERSDIR = "${leptonica}/include";

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erikarvstedt ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "tesseract";
  };
}
