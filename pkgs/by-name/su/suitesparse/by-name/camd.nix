{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "camd";
  moduleName = "CAMD";
  version = "3.3.5";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Set of routines for permuting sparse matrices prior to factorization";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
