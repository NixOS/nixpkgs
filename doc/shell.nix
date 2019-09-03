{ pkgs ? import ../. {} }:
(import ./default.nix { nix-shell = true; })
