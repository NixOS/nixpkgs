# Test ClamAV.

{ lib, pkgs, ... }:
{
  name = "clamav";
  nodes = {
    machine = {
      services.clamav = {
        daemon.enable = true;
        clamonacc.enable = true;

        daemon.settings = {
          OnAccessPrevention = true;
          OnAccessIncludePath = "/opt";
        };
      };

      # Add the definition for our test file.
      # We cannot download definitions from Internet using freshclam in sandboxed test.
      systemd.tmpfiles.settings."10-eicar"."/var/lib/clamav/test.hdb".L.argument = "${pkgs.runCommand
        "test.hdb"
        { }
        ''
          echo CLAMAVTEST > testfile
          ${lib.getExe' pkgs.clamav "sigtool"} --sha256 testfile > $out
        ''
      }";

      # Test using /opt as the ClamAV on-access scanner-protected directory.
      systemd.tmpfiles.settings."10-testdir"."/opt".d = { };
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
