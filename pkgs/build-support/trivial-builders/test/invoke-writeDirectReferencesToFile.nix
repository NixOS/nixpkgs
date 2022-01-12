{ pkgs ? import ../../../.. { config = {}; overlays = []; } }:
pkgs.lib.mapAttrs
  (_k: v: pkgs.writeDirectReferencesToFile v)
  (import ./sample.nix { inherit pkgs; })
