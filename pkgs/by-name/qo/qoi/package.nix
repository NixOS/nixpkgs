{
  fetchFromGitHub,
  lib,
  libpng,
  stb,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qoi";
  version = "0-unstable-2023-08-10"; # no upstream version yet.

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "qoi";
    rev = "19b3b4087b66963a3699ee45f05ec9ef205d7c0e";
    hash = "sha256-E1hMtjMuDS2zma2s5hlHby/sroRGhtyZm9gLQ+VztsM=";
  };

  patches = [
    # https://github.com/phoboslab/qoi/pull/322
    ./add-install-target-and-pc-module.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  enableParalleBuilding = true;

  buildInputs = [ libpng ];

  # Don't bloat the header-only output with binaries
  propagatedBuildOutputs = [ ];

  makeFlags = [
    "CFLAGS=-I${lib.getDev stb}/include/stb"
    "PREFIX=${placeholder "dev"}"
    "BINDIR=${placeholder "out"}/bin"
  ];

  meta = {
    description = "'Quite OK Image Format' for fast, lossless image compression";
    mainProgram = "qoiconv";
    homepage = "https://qoiformat.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.all;
  };
})
