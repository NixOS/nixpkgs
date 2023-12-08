{ lib
, pkgs
, writeMultipleReferencesToFile ? pkgs.writeMultipleReferencesToFile
}:

writeMultipleReferencesToFile
  (builtins.attrValues (import ./sample.nix { inherit pkgs; }))
