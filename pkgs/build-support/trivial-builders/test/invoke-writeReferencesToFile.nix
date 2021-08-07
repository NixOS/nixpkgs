{ pkgs ? import ../../../.. { config = {}; overlays = []; } }:
pkgs.lib.mapAttrs
  (k: v: pkgs.writeReferencesToFile v)
  (import ./sample.nix { inherit pkgs; })
