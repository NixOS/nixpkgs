{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "stepcode";
  version = "0.8.2-unstable-2026-02-09";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepcode";
    repo = "stepcode";
    rev = "74b6fe45751bd60be749bc80766f38745d29ed72";
    hash = "sha256-RDYHRvotBd6xBuo6eZ6ZB8RHJz5suQ5Rx8LeZlbbBGQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Library for reading and writing STEP Part 21 exchange files";
    homepage = "https://github.com/stepcode/stepcode";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      wishstudio
    ];
    platforms = lib.platforms.all;
  };
}
