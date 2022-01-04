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
    migration = release.tests.containers-migration;
    activation = release.tests.containers-config-activation;
    imperative = release.tests.containers-next-imperative;
  };
}
