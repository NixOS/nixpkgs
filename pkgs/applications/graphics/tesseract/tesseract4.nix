{ stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkgconfig
, leptonica, libpng, libtiff, icu, pango, opencl-headers }:

stdenv.mkDerivation rec {
  name = "tesseract-${version}";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "1b5fi2vibc4kk9b30kkk4ais4bw8fbbv24bzr5709194hb81cav8";
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
