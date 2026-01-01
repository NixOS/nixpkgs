{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmp,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.3.1";
  pname = "form";

  src = fetchFromGitHub {
    owner = "form-dev";
    repo = "form";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZWpfPeTekHEALqXVF/nLkcNsrkt17AKm2B/uydUBfvo=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gmp
    zlib
  ];

<<<<<<< HEAD
  meta = {
    description = "Symbolic manipulation of very big expressions";
    homepage = "https://www.nikhef.nl/~form/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.veprbl ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Symbolic manipulation of very big expressions";
    homepage = "https://www.nikhef.nl/~form/";
    license = licenses.gpl3;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
