{
  lib,
  stdenv,
  mkDerivation,
  cholmod,
  umfpack,
  blas,
  llvmPackages,
  suitesparse-config,
}:

mkDerivation {
  pname = "paru";
  moduleName = "ParU";
  version = "1.1.0";

  buildInputs = [
    blas
  ]
  ++ lib.optional stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    cholmod
    umfpack
    suitesparse-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
    (lib.cmakeFeature "BLA_VENDOR" "Generic")
  ];

  meta = {
    description = "Parallel multifrontal LU factorization algorithms";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
