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
  version = "0-unstable-2025-11-13"; # no upstream version yet.

  src = fetchFromGitHub {
    owner = "phoboslab";
    repo = "qoi";
    rev = "44b233a95eda82fbd2e39a269199b73af0f4c4c3";
    hash = "sha256-W5JG9Nz4NI2KZmUEtxEiGH7oxfAzEIaUyXTbSB25hZw=";
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
