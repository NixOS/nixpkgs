{ stdenv, fetchurl, autoconf, automake, libtool, leptonica, libpng, libtiff
, enableLanguages ? null
}:

with stdenv.lib;

let
  majVersion = "3.02";
  version = "${majVersion}.02";

  mkLang = lang: sha256: let
    src = fetchurl {
      url = "http://tesseract-ocr.googlecode.com/files/tesseract-ocr-${majVersion}.${lang}.tar.gz";
      inherit sha256;
    };
  in "tar xfvz ${src} -C $out/share/ --strip=1";

  wantLang = name: const (enableLanguages == null || elem name enableLanguages);

  extraLanguages = mapAttrsToList mkLang (filterAttrs wantLang {
    cat = "0d1smiv1b3k9ay2s05sl7q08mb3ln4w5iiiymv2cs8g8333z8jl9";
    rus = "059336mkhsj9m3hwfb818xjlxkcdpy7wfgr62qwz65cx914xl709";
    spa = "1c9iza5mbahd9pa7znnq8yv09v5kz3gbd2sarcgcgc1ps1jc437l";
    nld = "162acxp1yb6gyki2is3ay2msalmfcsnrlsd9wml2ja05k94m6bjy";
    eng = "1y5xf794n832s3lymzlsdm2s9nlrd2v27jjjp0fd9xp7c2ah4461";
    slv = "0rqng43435cly32idxm1lvxkcippvc3xpxbfizwq5j0155ym00dr";
    jpn = "07v8pymd0iwyzh946lxylybda20gsw7p4fsb09jw147955x49gq9";
  });
in

stdenv.mkDerivation rec {
  name = "tesseract-${version}";

  src = fetchurl {
    url = "http://tesseract-ocr.googlecode.com/files/tesseract-ocr-${version}.tar.gz";
    sha256 = "0g81m9y4iydp7kgr56mlkvjdwpp3mb01q385yhdnyvra7z5kkk96";
  };

  buildInputs = [ autoconf automake libtool leptonica libpng libtiff ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
      ./autogen.sh
      substituteInPlace "configure" \
        --replace 'LIBLEPT_HEADERSDIR="/usr/local/include /usr/include"' \
                  'LIBLEPT_HEADERSDIR=${leptonica}/include'
  '';

  postInstall = concatStringsSep "; " extraLanguages;

  meta = {
    description = "OCR engine";
    homepage = http://code.google.com/p/tesseract-ocr/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
