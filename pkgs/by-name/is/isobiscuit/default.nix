{
  lib,
  fetchPypi,
  python3Packages,
}:

import ./package.nix {
  inherit
    lib
    fetchPypi
    buildPythonPackage
    python3Packages
    ;
}
