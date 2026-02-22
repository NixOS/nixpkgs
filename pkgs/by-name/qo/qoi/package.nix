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
  version = "0-unstable-2026-02-04"; # no upstream version yet.

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "qoi";
    rev = "a2f3ab61bc1f3271aad699abc47653df36162bbc";
    hash = "sha256-NLvePFZGTWlY+fDInLqnLriUTyBfh0koHQwik917vQY=";
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
