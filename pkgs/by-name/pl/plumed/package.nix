{
  stdenv,
  lib,
  fetchFromGitHub,
  blas,

  # passthru
  python3Packages,
  nix-update-script,
}:

assert !blas.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "plumed";
  version = "2.10.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IHmELGzF4LjpNNPuojT+QJ2rKt2d5zPhGixFDYbwTg0=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ blas ];

  enableParallelBuilding = true;

  passthru = {
    tests = {
      pythonPackage = python3Packages.plumed;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.sheepforce ];
    mainProgram = "plumed";
  };
})
