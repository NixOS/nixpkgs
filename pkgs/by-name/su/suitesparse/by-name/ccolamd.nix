{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "ccolamd";
  moduleName = "CCOLAMD";
  version = "3.3.5";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Constrained column approximate minimum degree ordering";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
