import ./make-test-python.nix (
  {
    pkgs,
    latestKernel ? false,
    ...
  }:

  {
    name = "disable-installer-tools";

    nodes.machine =
      { pkgs, lib, ... }:
      {
        system.disableInstallerTools = true;
        boot.enableContainers = false;
        environment.defaultPackages = [ ];
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

      with subtest("nixos installer tools should not be included"):
          machine.fail("which nixos-rebuild")
          machine.fail("which nixos-install")
          machine.fail("which nixos-generate-config")
          machine.fail("which nixos-enter")
          machine.fail("which nixos-version")
          machine.fail("which nixos-build-vms")

      with subtest("perl should not be included"):
          machine.fail("which perl")
    '';
  }
)
