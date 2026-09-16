# Test ClamAV with multiple TCPAddr options enabled.

{ lib, pkgs, ... }:
{
  name = "clamav";
  nodes = {
    machine = {
      imports = [ ./definition.nix ];

      services.clamav.daemon = {
        enable = true;
        socketActivation = false;
        settings = {
          LogTime = true;
          LogClean = true;
          LogVerbose = true;
          ExtendedDetectionInfo = true;
          ExitOnOOM = true;
          TCPSocket = 3310;
          TCPAddr = [
            "127.0.0.1"
            "::1"
          ];
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("default.target")

    machine.succeed("echo CLAMAVTEST > /opt/testfile")
    machine.succeed("echo OK > /opt/ok")

    # Check connection over first TCP socket works
    machine.succeed("sed '/LocalSocket|127.0.0.1/d' /etc/clamav/clamd.conf > tcp1.conf")
    machine.succeed("clamdscan -c tcp1.conf /opt/ok")
    machine.fail("clamdscan -c tcp1.conf /opt/testfile")

    # Check connection over first TCP socket works
    machine.succeed("sed '/LocalSocket|::1/d' /etc/clamav/clamd.conf > tcp2.conf")
    machine.succeed("clamdscan -c tcp2.conf /opt/ok")
    machine.fail("clamdscan -c tcp2.conf /opt/testfile")

    # Check connection over Unix socket works
    machine.succeed("sed '/TCP/d' /etc/clamav/clamd.conf > unix.conf")
    machine.succeed("clamdscan -c unix.conf /opt/ok")
    machine.succeed("clamdscan -c unix.conf --fdpass /opt/ok")
    machine.fail("clamdscan -c unix.conf /opt/testfile")
    machine.fail("clamdscan -c unix.conf --fdpass /opt/testfile")
  '';
}
