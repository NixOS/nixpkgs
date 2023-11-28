{ pkgs
, writeReferencesToFile ? pkgs.writeReferencesToFile
}:
pkgs.lib.mapAttrs
  (k: v: writeReferencesToFile v)
  (import ./sample.nix { inherit pkgs; })
