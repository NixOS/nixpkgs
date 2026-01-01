{
  lib,
  stdenv,
  fetchFromGitHub,
}:
<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "defaultbrowser";
  version = "1.1-unstable-2024-09-04";
=======

stdenv.mkDerivation {
  pname = "defaultbrowser";
  version = "unstable-2020-07-23";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kerma";
    repo = "defaultbrowser";
<<<<<<< HEAD
    rev = "ad812c4e678a1e1f04cc44b8ab6d1ed5b8733359";
    hash = "sha256-lZgIfbvTxlxlEh/NvNonZ1fVvcFynXWW1Fu2f9FIWiU=";
=======
    rev = "d2860c00dd7fbb5d615232cc819d7d492a6a6ddb";
    sha256 = "sha256-SelUQXoKtShcDjq8uKg3wM0kG2opREa2DGQCDd6IsOQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  makeFlags = [
    "CC=cc"
    "PREFIX=$(out)"
  ];

<<<<<<< HEAD
  meta = {
    mainProgram = "defaultbrowser";
    description = "Command line tool for getting and setting a default browser (HTTP handler) in Mac OS X";
    homepage = "https://github.com/kerma/defaultbrowser";
    platforms = lib.platforms.darwin;
    maintainers = [ ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    mainProgram = "defaultbrowser";
    description = "Command line tool for getting and setting a default browser (HTTP handler) in Mac OS X";
    homepage = "https://github.com/kerma/defaultbrowser";
    platforms = platforms.darwin;
    maintainers = [ ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
