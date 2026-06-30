{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "rbio";
  moduleName = "RBio";
  version = "4.3.5";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "MATLAB Toolbox for reading/writing sparse matrices in Rutherford/Boeing format";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
