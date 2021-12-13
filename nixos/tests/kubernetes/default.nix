{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:
let
  dns = import ./dns.nix { inherit system pkgs; };
  rbac = import ./rbac.nix { inherit system pkgs; };
  # TODO kubernetes.e2e should eventually replace kubernetes.rbac when it works
  # e2e = import ./e2e.nix { inherit system pkgs; };
in
{
  dns-single-node = dns.singlenode.test;
  dns-multi-node = dns.multinode.test;
  # timed out: https://hydra.nixos.org/build/160710933
  #rbac-single-node = rbac.singlenode.test;
  # timed out: https://hydra.nixos.org/build/160711286
  #rbac-multi-node = rbac.multinode.test;
}
