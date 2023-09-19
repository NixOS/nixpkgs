import ./make-test-python.nix ({ pkgs, latestKernel ? false, ... }:

let
  nixos-enter-override = pkgs.writeShellScriptBin "nixos-enter" ''
    exit 0
  '';
in

{
  name = "disable-installer-tools";

  nodes = {
    machine = { ... }: {
      system.disableInstallerTools = true;

      boot.enableContainers = false;
      environment.defaultPackages = [ ];
    };

    machine2 = { ... }: {
      system.installerTools = {
        nixos-version.enable = false;
        nixos-enter.package = nixos-enter-override;
      };
      boot.enableContainers = false;
      environment.defaultPackages = [ ];
    };
  };

  testScript = ''
    def wait_for_tty(machine: Machine) -> None:
      machine.wait_for_unit("multi-user.target")
      machine.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    # Boot the machines in parallel
    start_all()

    wait_for_tty(machine)

    with subtest("nixos installer tools should not be included"):
        machine.fail("which nixos-rebuild")
        machine.fail("which nixos-install")
        machine.fail("which nixos-generate-config")
        machine.fail("which nixos-enter")
        machine.fail("which nixos-version")
        machine.fail("which nixos-build-vms")

    with subtest("perl should not be included"):
        machine.fail("which perl")

    wait_for_tty(machine2)

    with subtest("machine2 should not have nixos-version"):
        machine2.succeed("which nixos-rebuild")
        machine2.succeed("which nixos-install")
        machine2.succeed("which nixos-generate-config")
        machine2.succeed("which nixos-enter")
        machine2.fail("which nixos-version")
        machine2.succeed("which nixos-build-vms")

    with subtest("machine2 should have the overridden nixos-enter"):
      machine2.succeed('[ "$(realpath $(which nixos-enter))" == "${nixos-enter-override}/bin/nixos-enter" ]')
  '';
})
