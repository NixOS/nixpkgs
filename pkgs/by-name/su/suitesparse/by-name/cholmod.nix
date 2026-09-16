{
  lib,
  stdenv,
  mkDerivation,
  amd,
  colamd,
  camd,
  ccolamd,
  blas,
  lapack,
  llvmPackages,
  suitesparse-config,
}:
assert (blas.isILP64 == lapack.isILP64);

mkDerivation {
  pname = "cholmod";
  moduleName = "CHOLMOD";
  version = "5.3.4";

  buildInputs = [
    blas
    lapack
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    amd
    colamd
    camd
    ccolamd
    suitesparse-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
    (lib.cmakeFeature "BLA_VENDOR" "Generic")
  ];

  doCheck = true;

  meta = {
    description = "Sparse CHOLesky MODification package";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
