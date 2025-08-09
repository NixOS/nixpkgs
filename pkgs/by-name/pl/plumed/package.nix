{
  stdenv,
  lib,
  fetchFromGitHub,
  blas,
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "plumed";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
    hash = "sha256-KN412t64tp3QUQkhpLU3sAYDosQ3hw9HqpT1fzt5fwA=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ blas ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
