{ system ? builtins.currentSystem
, pkgs ? import ../../.. { inherit system; }
, lib ? pkgs.lib
}:
let
  allK3s = {
    inherit (pkgs)
      k3s
      k3s_1_23
      k3s_1_24
      k3s_1_25
      k3s_1_26
      ;
  };
in
{
  # Run a single node k3s cluster and verify a pod can run
  single-node = lib.mapAttrs (_: k3s: import ./single-node.nix { inherit system pkgs k3s; }) allK3s;
  # Run a multi-node k3s cluster and verify pod networking works across nodes
  multi-node = lib.mapAttrs (_: k3s: import ./multi-node.nix { inherit system pkgs k3s; }) allK3s;
}
