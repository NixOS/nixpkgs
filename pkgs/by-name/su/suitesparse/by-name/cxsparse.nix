{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "cxsparse";
  moduleName = "CXSparse";
  version = "4.4.2";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Concise eXtended Sparse Matrix Package";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
