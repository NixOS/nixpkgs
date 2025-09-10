{ pkgs, lib, ... }:

let
  multipass-image = import ../release.nix {
    configuration = {
      # Building documentation makes the test unnecessarily take a longer time:
      documentation.enable = lib.mkForce false;
    };
  };

in
{
  name = "multipass";

  meta.maintainers = [ ];

  nodes.machine =
    { lib, ... }:
    {
      virtualisation = {
        cores = 1;
        memorySize = 1024;
        diskSize = 4096;

        multipass.enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("multipass.service")
    machine.wait_for_file("/var/lib/multipass/data/multipassd/network/multipass_subnet")

    # Wait for Multipass to settle
    machine.sleep(1)

    machine.succeed("multipass list")
  '';
}
