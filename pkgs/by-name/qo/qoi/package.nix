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

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  enableParalleBuilding = true;

  buildInputs = [ libpng ];

  installPhase = ''
    runHook preInstall

    # Conversion utility for images->qoi. Not usually needed for development.
    mkdir -p ${placeholder "out"}/bin
    install qoiconv ${placeholder "out"}/bin

    # The actual single-header implementation. Nothing to compile, just install.
    mkdir -p ${placeholder "dev"}/include/
    install qoi.h ${placeholder "dev"}/include

    runHook postInstall
  '';

  makeFlags = [
    "CFLAGS=-I${lib.getDev stb}/include/stb"
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
