{ system ? builtins.currentSystem
, pkgs ? import ../../.. { inherit system; }
, lib ? pkgs.lib
}:
let
  allRKE2 = lib.filterAttrs (n: _: lib.strings.hasPrefix "rke2" n) pkgs;
in
{
  # Run a single node rke2 cluster and verify a pod can run
  singleNode = lib.mapAttrs (_: rke2: import ./single-node.nix { inherit system pkgs rke2; }) allRKE2;
  # Run a multi-node rke2 cluster and verify pod networking works across nodes
  multiNode = lib.mapAttrs (_: rke2: import ./multi-node.nix { inherit system pkgs rke2; }) allRKE2;
}
