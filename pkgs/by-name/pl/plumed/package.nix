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
  version = "2.10.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K22IE4bMk6b96Ac2yA2+dfGqy4BeoRuymYBk5hwrVok=";
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
