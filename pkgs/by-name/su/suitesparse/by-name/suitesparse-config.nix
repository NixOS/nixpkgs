{
  lib,
  stdenv,
  mkDerivation,
  blas,
  llvmPackages,
}:

mkDerivation {
  pname = "config";
  moduleName = "SuiteSparse_config";
  version = "7.12.1";

  buildInputs = [
    blas
  ];

  propagatedBuildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
    (lib.cmakeFeature "BLA_VENDOR" "Generic")
  ];

  meta = {
    description = "Library with common functions and configuration for most suitesparse packages";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
