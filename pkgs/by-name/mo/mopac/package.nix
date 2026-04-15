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

stdenv.mkDerivation (finalAttrs: {
  pname = "mopac";
  version = "23.2.4";

  src = fetchFromGitHub {
    owner = "openmopac";
    repo = "mopac";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Pc9o2ZEHNhU0Dy36vR8egt6hSbTdVmRhSHXB+zNexi0=";
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
})
