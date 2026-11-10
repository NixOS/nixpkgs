# Test ClamAV.

{ lib, pkgs, ... }:
{
  name = "clamav";
  nodes = {
    machine = {
      services.clamav = {
        daemon.enable = true;
        clamonacc.enable = true;

        fangfrisch = {
          enable = true;
          urlhaus.authKeyFile = "/run/secrets/urlhaus-auth-key";
        };

        daemon.settings = {
          OnAccessPrevention = true;
          OnAccessIncludePath = "/opt";
        };
      };

      # fangfrisch loads the URLhaus key from this file via LoadCredential.
      systemd.tmpfiles.settings."10-urlhaus-auth-key"."/run/secrets".d = { };
      systemd.tmpfiles.settings."10-urlhaus-auth-key"."/run/secrets/urlhaus-auth-key".f = {
        mode = "0400";
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

    # The URLhaus key must reach fangfrisch through a systemd credential and a
    # runtime copy of the configuration, not through the world-readable store.
    unit = machine.succeed("systemctl cat clamav-fangfrisch.service")
    assert "LoadCredential=urlhaus-auth-key:/run/secrets/urlhaus-auth-key" in unit
    assert "--conf $RUNTIME_DIRECTORY/fangfrisch.conf" in unit

    prepare = machine.succeed("systemctl cat clamav-fangfrisch.service | sed -n 's/^ExecStartPre=//p'").strip()
    store_config = machine.succeed(f"grep -oE '/nix/store/[a-z0-9]+-fangfrisch.conf' {prepare}").strip()
    assert "test-key" not in machine.succeed(f"cat {store_config}")

    machine.succeed("mkdir -p /tmp/cred /tmp/rt")
    machine.succeed("echo test-key > /tmp/cred/urlhaus-auth-key")
    machine.succeed(f"CREDENTIALS_DIRECTORY=/tmp/cred RUNTIME_DIRECTORY=/tmp/rt {prepare}")
    assert "auth_key = test-key" in machine.succeed("cat /tmp/rt/fangfrisch.conf")

    # Write test file into the test directory.
    # This won't trigger ClamAV as it scans on file open.
    machine.succeed("echo CLAMAVTEST > /opt/testfile")

    machine.fail("cat /opt/testfile")
  '';
}
