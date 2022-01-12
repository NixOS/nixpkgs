{ pkgs ? import ../../../.. { config = {}; overlays = []; } }:
pkgs.lib.mapAttrs
  (_k: v: pkgs.writeReferencesToFile v)
  (import ./sample.nix { inherit pkgs; })
