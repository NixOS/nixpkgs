{
  fetchFromGitHub,
  lib,
  libpng,
  nix-update-script,
  stb,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qoi";
  version = "0-unstable-2026-02-14"; # no upstream version yet.

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "qoi";
    rev = "6fff9b70dd79b12f808b0acc5cb44fde9998725e";
    hash = "sha256-pw/lflPXLVdM/Qg685/nAlGt5bQC5WU6t496z6xWHx0=";
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

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "'Quite OK Image Format' for fast, lossless image compression";
    mainProgram = "qoiconv";
    homepage = "https://qoiformat.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "qoi" ];
  };
})
