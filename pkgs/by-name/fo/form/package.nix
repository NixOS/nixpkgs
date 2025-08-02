{
  lib,
  stdenv,
  fetchurl,
  gmp,
  zlib,
}:

stdenv.mkDerivation {
  version = "4.3.1";
  pname = "form";

  # This tarball is released by author, it is not downloaded from tag, so can't use fetchFromGitHub
  src = fetchurl {
    url = "https://github.com/vermaseren/form/releases/download/v4.3.1/form-4.3.1.tar.gz";
    sha256 = "sha256-8fUS3DT+m71rGfLf7wX8uZEt+0PINop1t5bsRy7ou84=";
  };

  buildInputs = [
    gmp
    zlib
  ];

  meta = {
    description = "FORM project for symbolic manipulation of very big expressions";
    homepage = "https://www.nikhef.nl/~form/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.veprbl ];
    platforms = lib.platforms.unix;
  };
}
