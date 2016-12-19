{ stdenv, fetchFromGitHub, pkgconfig, leptonica, libpng, libtiff
, icu, pango, opencl-headers
}:

stdenv.mkDerivation rec {
  name = "tesseract-${version}";
  version = "3.04.01";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "0h1x4z1h86n2gwknd0wck6gykkp99bmm02lg4a47a698g4az6ybv";
  };

  tessdata = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata";
    rev = "3cf1e2df1fe1d1da29295c9ef0983796c7958b7d";
    sha256 = "1v4b63v5nzcxr2y3635r19l7lj5smjmc9vfk0wmxlryxncb4vpg7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ leptonica libpng libtiff icu pango opencl-headers ];

  LIBLEPT_HEADERSDIR = "${leptonica}/include";

  postInstall = "cp -Rt \"$out/share/tessdata\" \"$tessdata/\"*";

  meta = {
    description = "OCR engine";
    homepage = http://code.google.com/p/tesseract-ocr/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
