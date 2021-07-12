{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkg-config
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

  nativeBuildInputs = [ pkg-config autoreconfHook autoconf-archive ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ viric earvstedt ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
