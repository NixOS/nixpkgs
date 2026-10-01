{
  lib,
  stdenv,
  mkDerivation,
  amd,
  cholmod,
  blas,
  suitesparse-config,
}:

mkDerivation {
  pname = "umfpack";
  moduleName = "UMFPACK";
  version = "6.3.7";

  buildInputs = [
    amd
    cholmod
    blas
  ];

  propagatedBuildInputs = [
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
