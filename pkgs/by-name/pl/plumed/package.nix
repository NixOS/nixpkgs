{
  stdenv,
  lib,
  fetchFromGitHub,
  blas,
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "plumed";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
    hash = "sha256-aFX8u+XNb7LARm1jtzWzIvZE5qHFaudtp45Om1Fridg=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ blas ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.sheepforce ];
=======
  meta = with lib; {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
