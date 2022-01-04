{ lib ? import ../../lib, ... }:
let
  eval-config-minimal = import ./eval-config-minimal.nix { inherit lib; };
in
/*
  This attribute set appears as lib.nixos in the flake, or can be imported
  using a binding like `nixosLib = import (nixpkgs + "/nixos/lib") { }`.
*/
{
  inherit (eval-config-minimal)
    evalModules
    ;
}
