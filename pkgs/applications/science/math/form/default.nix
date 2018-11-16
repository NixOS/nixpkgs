{ stdenv, fetchurl, gmp, zlib }:

stdenv.mkDerivation rec {
  version = "4.2.0";
  name = "form-${version}";

  # This tarball is released by author, it is not downloaded from tag, so can't use fetchFromGitHub
  src = fetchurl {
    url = "https://github.com/vermaseren/form/releases/download/v4.2.0/form-4.2.0.tar.gz";
    sha256 = "19528aphn4hvm151lyyhd7wz0bp2s3rla8jv6s7d8jwfp5ljzysm";
  };

  buildInputs = [ gmp zlib ];

  meta = with stdenv.lib; {
    description = "The FORM project for symbolic manipulation of very big expressions";
    homepage = https://www.nikhef.nl/~form/;
    license = licenses.gpl3;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
}
