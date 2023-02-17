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
    general = release.tests.containers-next;
    migration = release.tests.containers-next-migration;
    activation = release.tests.containers-next-config-activation;
    imperative = release.tests.containers-next-imperative;
    wireguard = release.tests.containers-next-wireguard;
  };
}
