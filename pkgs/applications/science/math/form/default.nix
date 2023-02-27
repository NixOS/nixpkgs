{ lib, stdenv, fetchurl, gmp, zlib }:

stdenv.mkDerivation {
  version = "4.3.0";
  pname = "form";

  # This tarball is released by author, it is not downloaded from tag, so can't use fetchFromGitHub
  src = fetchurl {
    url = "https://github.com/vermaseren/form/releases/download/v4.3.0/form-4.3.0.tar.gz";
    sha256 = "sha256-sjTg0JX3PssJBM3DsNjYMjqfp/RncKUvsiJnxiSq+/Y=";
  };

  buildInputs = [ gmp zlib ];

  meta = with lib; {
    description = "The FORM project for symbolic manipulation of very big expressions";
    homepage = "https://www.nikhef.nl/~form/";
    license = licenses.gpl3;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
}
