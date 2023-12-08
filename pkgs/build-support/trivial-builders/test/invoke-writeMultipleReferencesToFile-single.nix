{ pkgs
, writeMultipleReferencesToFile ? pkgs.writeMultipleReferencesToFile
}:
import ./invoke-writeReferencesToFile.nix {
  writeReferencesToFile = path: writeMultipleReferencesToFile [ path ];
  inherit pkgs;
}
