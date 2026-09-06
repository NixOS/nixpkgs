{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "amd";
  moduleName = "AMD";
  version = "3.3.4";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Set of routines for permuting sparse matrices prior to factorization";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
