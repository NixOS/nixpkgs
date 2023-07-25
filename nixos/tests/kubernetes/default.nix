{ system ? builtins.currentSystem
, pkgs ? import ../../.. { inherit system; }
}:
let
  dns = import ./dns.nix { inherit system pkgs; };
  rbac = import ./rbac.nix { inherit system pkgs; };
in
{
  dns-single-node = dns.singlenode.test;
  dns-multi-node = dns.multinode.test;
  rbac-single-node = rbac.singlenode.test;
  rbac-multi-node = rbac.multinode.test;
}
