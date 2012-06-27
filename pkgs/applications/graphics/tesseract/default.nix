{ stdenv, fetchurl, autoconf, automake, libtool, leptonica, libpng, libtiff }:

let
  f = lang : sha256 : let
      src = fetchurl {
        url = "http://tesseract-ocr.googlecode.com/files/${lang}.traineddata.gz";
        inherit sha256;
      };
    in 
      "gunzip -c ${src} > $out/share/tessdata/${lang}.traineddata";

  extraLanguages = ''
    ${f "cat" "1qndk8qygw9bq7nzn7kzgxkm3jhlq7jgvdqpj5id4rrcaavjvifw"}
    ${f "rus" "0yjzks189bgcmi2vr4v0l0fla11qdrw3cb1nvpxl9mdis8qr9vcc"}
    ${f "spa" "1q1hw3qi95q5ww3l02fbhjqacxm34cp65fkbx10wjdcg0s5p9q2x"}
    ${f "nld" "0cbqfhl2rwb1mg4y1140nw2vhhcilc0nk7bfbnxw6bzj1y5n49i8"}
  '';
in

stdenv.mkDerivation {
  name = "tesseract-3.0.1";

  src = fetchurl {
    url = http://tesseract-ocr.googlecode.com/files/tesseract-3.01.tar.gz;
    sha256 = "c24b0bd278291bc93ab242f93841c1d8743689c943bd804afbc5b898dc0a1c9b";
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
    license = "Apache2.0";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
