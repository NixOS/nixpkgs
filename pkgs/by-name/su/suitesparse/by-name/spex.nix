{
  lib,
  stdenv,
  mkDerivation,
  llvmPackages,
  amd,
  colamd,
  gmp,
  mpfr,
  suitesparse-config,
}:

mkDerivation {
  pname = "spex";
  moduleName = "SPEX";
  version = "3.2.4";

  buildInputs = lib.optional stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    amd
    colamd
    gmp
    mpfr
    suitesparse-config
  ];

  meta = {
    description = "Software package for SParse EXact algebra";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
