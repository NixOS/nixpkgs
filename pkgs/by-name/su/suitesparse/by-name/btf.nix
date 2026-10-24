{
  lib,
  mkDerivation,
  suitesparse-config,
}:

mkDerivation {
  pname = "btf";
  moduleName = "BTF";
  version = "2.3.3";

  propagatedBuildInputs = [ suitesparse-config ];

  meta = {
    description = "Software package for permuting a matrix into block upper triangular form";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
