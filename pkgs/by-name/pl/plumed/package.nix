{
  stdenv,
  lib,
  fetchFromGitHub,
  blas,
}:

assert !blas.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "plumed";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aFX8u+XNb7LARm1jtzWzIvZE5qHFaudtp45Om1Fridg=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ blas ];

  enableParallelBuilding = true;

  meta = {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
