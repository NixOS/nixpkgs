# FIXME remove before merging!

{ nixpkgs }:
let
  release = import ./nixos/release.nix {
    supportedSystems = [ "x86_64-linux" ];
    inherit nixpkgs;
  };
in

{
  container-tests = {
    general = release.tests.containers-next.basic;
    migration = release.tests.containers-next.migration;
    activation = release.tests.containers-next.config-activation;
    imperative = release.tests.containers-next.imperative;
    nat = release.tests.containers-next.nat;
    daemon-mount = release.tests.containers-next.daemon-mount;
    wireguard = release.tests.containers-next.wireguard;
  };
}
