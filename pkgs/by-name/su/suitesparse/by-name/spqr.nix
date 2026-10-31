{
  lib,
  mkDerivation,
  cholmod,
  blas,
  lapack,
  suitesparse-config,
}:
assert (blas.isILP64 == lapack.isILP64);

mkDerivation {
  pname = "spqr";
  moduleName = "SPQR";
  version = "4.3.6";

  buildInputs = [
    blas
    lapack
  ];

  propagatedBuildInputs = [
    cholmod
    suitesparse-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
    (lib.cmakeFeature "BLA_VENDOR" "Generic")
  ];

  meta = {
    description = "Multithreaded, multifrontal, rank-revealing sparse QR factorization method";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
