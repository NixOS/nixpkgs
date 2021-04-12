let
  release = import ./nixos/release.nix {
    supportedSystems = [ "x86_64-linux" ];
  };
in

{
  container-tests = {
    general = release.tests.containers-next;
    migration = release.tests.container-migration;
    activation = release.tests.containers-config-activation;
  };
}
