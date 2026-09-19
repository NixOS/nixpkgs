# Test ClamAV.

{ lib, pkgs, ... }:
{
  name = "clamav";
  nodes = {
    machine = {
      imports = [ ./definition.nix ];

      services.clamav = {
        daemon.enable = true;
        clamonacc.enable = true;

        daemon.settings = {
          OnAccessPrevention = true;
          OnAccessIncludePath = "/opt";
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("default.target")

    # Write test file into the test directory.
    # This won't trigger ClamAV as it scans on file open.
    machine.succeed("echo CLAMAVTEST > /opt/testfile")

    machine.fail("cat /opt/testfile")
  '';
}
