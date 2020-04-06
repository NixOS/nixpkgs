{ stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkgconfig
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

  nativeBuildInputs = [ pkgconfig autoreconfHook autoconf-archive ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

  meta = {
    description = "OCR engine";
    homepage = https://github.com/tesseract-ocr/tesseract;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ viric earvstedt ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
