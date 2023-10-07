{ pkgs ? import ../../../.. { config = {}; overlays = []; } }:
pkgs.lib.mapAttrs
  (k: v: pkgs.writeDirectReferencesToFile v)
  (import ./sample.nix { inherit pkgs; })
