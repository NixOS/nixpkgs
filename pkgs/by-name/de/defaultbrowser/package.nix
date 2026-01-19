{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "defaultbrowser";
  version = "1.1-unstable-2024-09-04";

  src = fetchFromGitHub {
    owner = "kerma";
    repo = "defaultbrowser";
    rev = "ad812c4e678a1e1f04cc44b8ab6d1ed5b8733359";
    hash = "sha256-lZgIfbvTxlxlEh/NvNonZ1fVvcFynXWW1Fu2f9FIWiU=";
  };

  makeFlags = [
    "CC=cc"
    "PREFIX=$(out)"
  ];

  meta = {
    mainProgram = "defaultbrowser";
    description = "Command line tool for getting and setting a default browser (HTTP handler) in Mac OS X";
    homepage = "https://github.com/kerma/defaultbrowser";
    platforms = lib.platforms.darwin;
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
