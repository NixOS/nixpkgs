{
  lib,
  mkDerivation,
  amd,
  colamd,
  btf,
  cholmod,
  suitesparse-config,
}:

mkDerivation {
  pname = "klu";
  moduleName = "KLU";
  version = "2.3.6";

  propagatedBuildInputs = [
    amd
    btf
    colamd
    cholmod
    suitesparse-config
  ];

  meta = {
    description = "Set of routines for solving sparse linear systems of equations";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
