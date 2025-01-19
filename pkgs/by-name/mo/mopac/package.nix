{
  stdenv,
  lib,
  gfortran,
  fetchFromGitHub,
  cmake,
  blas,
  lapack,
  python3Packages,
}:

assert blas.isILP64 == lapack.isILP64;

stdenv.mkDerivation rec {
  pname = "mopac";
  version = "23.0.3";

  src = fetchFromGitHub {
    owner = "openmopac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-y9/b+ro9CgDo0ld9q+3xaCFE9J5ssZp6W9ct6WQgD/o=";
  };

  nativeBuildInputs = [
    gfortran
    cmake
  ];

  buildInputs = [
    blas
    lapack
  ];

  checkInputs = with python3Packages; [
    python
    numpy
  ];

  doCheck = true;

  preCheck = ''
    export OMP_NUM_THREADS=2
  '';

  meta = {
    description = "Semiempirical quantum chemistry";
    homepage = "https://github.com/openmopac/mopac";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
  };
}
