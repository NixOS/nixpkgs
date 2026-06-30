{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "ldl";
  moduleName = "LDL";
  version = "3.3.3";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Sparse LDL' factorization and solve package";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
