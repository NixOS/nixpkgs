{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, leptonica, libpng, libtiff, icu, pango, opencl-headers }:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "3.05.00";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "11wrpcfl118wxsv2c3w2scznwb48c4547qml42s2bpdz079g8y30";
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
