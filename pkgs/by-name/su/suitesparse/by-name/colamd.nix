{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "colamd";
  moduleName = "COLAMD";
  version = "3.3.5";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Column approximate minimum degree ordering";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
