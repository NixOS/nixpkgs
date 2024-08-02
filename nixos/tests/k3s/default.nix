{
  system ? builtins.currentSystem,
  pkgs ? import ../../.. { inherit system; },
  lib ? pkgs.lib,
}:
let
  allK3s = lib.filterAttrs (n: _: lib.strings.hasPrefix "k3s_" n) pkgs;
in
{
  auto-deploy = lib.mapAttrs (_: k3s: import ./auto-deploy.nix { inherit system pkgs k3s; }) allK3s;
  etcd = lib.mapAttrs (
    _: k3s:
    import ./etcd.nix {
      inherit system pkgs k3s;
      inherit (pkgs) etcd;
    }
  ) allK3s;
  kubelet-config = lib.mapAttrs (
    _: k3s: import ./kubelet-config.nix { inherit system pkgs k3s; }
  ) allK3s;
  multi-node = lib.mapAttrs (_: k3s: import ./multi-node.nix { inherit system pkgs k3s; }) allK3s;
  single-node = lib.mapAttrs (_: k3s: import ./single-node.nix { inherit system pkgs k3s; }) allK3s;
}
