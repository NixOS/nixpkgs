{ system ? builtins.currentSystem
, pkgs ? import ../../.. { inherit system; }
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
  # rbac-single-node = rbac.singlenode.test;  # deactivated for 21.11 as test is broken (time out) since 2022-01-01
  # rbac-multi-node = rbac.multinode.test;  # deactivated for 21.11 as test is broken (time out) since 2022-01-01
}
