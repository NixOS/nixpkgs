{ stdenv, fetchurl, autoconf, automake, libtool, leptonica, libpng, libtiff }:

let
  majVersion = "3.02";
  version = "${majVersion}.02";

  f = lang : sha256 : let
      src = fetchurl {
        url = "http://tesseract-ocr.googlecode.com/files/tesseract-ocr-${majVersion}.${lang}.tar.gz";
        inherit sha256;
      };
    in 
      "tar xfvz ${src} -C $out/share/ --strip=1";

  extraLanguages = ''
    ${f "cat" "0d1smiv1b3k9ay2s05sl7q08mb3ln4w5iiiymv2cs8g8333z8jl9"}
    ${f "rus" "059336mkhsj9m3hwfb818xjlxkcdpy7wfgr62qwz65cx914xl709"}
    ${f "spa" "1c9iza5mbahd9pa7znnq8yv09v5kz3gbd2sarcgcgc1ps1jc437l"}
    ${f "nld" "162acxp1yb6gyki2is3ay2msalmfcsnrlsd9wml2ja05k94m6bjy"}
    ${f "eng" "1y5xf794n832s3lymzlsdm2s9nlrd2v27jjjp0fd9xp7c2ah4461"}
    ${f "slv" "0rqng43435cly32idxm1lvxkcippvc3xpxbfizwq5j0155ym00dr"}
  '';
in

stdenv.mkDerivation rec {
  name = "tesseract-${version}";

  src = fetchurl {
    url = "http://tesseract-ocr.googlecode.com/files/tesseract-ocr-${version}.tar.gz";
    sha256 = "0g81m9y4iydp7kgr56mlkvjdwpp3mb01q385yhdnyvra7z5kkk96";
  };

  buildInputs = [ autoconf automake libtool leptonica libpng libtiff ];

  preConfigure = ''
      ./autogen.sh
      substituteInPlace "configure" \
        --replace 'LIBLEPT_HEADERSDIR="/usr/local/include /usr/include"' \
                  'LIBLEPT_HEADERSDIR=${leptonica}/include'
  '';

  postInstall = extraLanguages;

  meta = {
    description = "OCR engine";
    homepage = http://code.google.com/p/tesseract-ocr/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
