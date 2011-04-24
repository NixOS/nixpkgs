{ stdenv, fetchurl, libtiff }:

stdenv.mkDerivation {
  name = "tesseract-3.0.0";

  src = fetchurl {
    url = http://tesseract-ocr.googlecode.com/files/tesseract-3.00.tar.gz;
    sha256 = "111r9hy1rcs2ch4kdi9dkzwch3xg38vv379sf3cjpkswkigx8clw";
  };

  buildInputs = [ libtiff ];

  meta = {
    description = "OCR engine";
    homepage = http://code.google.com/p/tesseract-ocr/;
    license = "Apache2.0";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
