{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, leptonica, libpng, libtiff, icu, pango, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "1ca27zbjpx35nxh9fha410z3jskwyj06i5hqiqdc08s2d7kdivwn";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

  LIBLEPT_HEADERSDIR = "${leptonica}/include";

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ viric earvstedt ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
