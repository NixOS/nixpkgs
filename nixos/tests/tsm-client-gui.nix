# The tsm-client GUI first tries to connect to a server.
# We can't simulate a server, so we just check if
# it reports the correct connection failure error.
# After that the test persuades the GUI
# to show its main application window
# and verifies some configuration information.

import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "tsm-client";

  enableOCR = true;

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/x11.nix ];
    programs.tsmClient = {
      enable = true;
      package = pkgs.tsm-client-withGui;
      defaultServername = "testserver";
      servers.testserver = {
        # 192.0.0.8 is a "dummy address" according to RFC 7600
        server = "192.0.0.8";
        node = "SOME-NODE";
        passwdDir = "/tmp";
      };
    };
  };

  testScript = ''
    machine.succeed("which dsmj")  # fail early if this is missing
    machine.wait_for_x()
    machine.execute("DSM_LOG=/tmp dsmj -optfile=/dev/null >&2 &")

    # does it report the "TCP/IP connection failure" error code?
    machine.wait_for_window("IBM Spectrum Protect")
    machine.wait_for_text("ANS2610S")
    machine.send_key("esc")

    # it asks to continue to restore a local backupset now;
    # "yes" (return) leads to the main application window
    machine.wait_for_text("backupset")
    machine.send_key("ret")

    # main window: navigate to "Connection Information"
    machine.wait_for_text("Welcome")
    machine.send_key("alt-f")  # "File" menu
    machine.send_key("c")  # "Connection Information"

    # "Connection Information" dialog box
    machine.wait_for_window("Connection Information")
    machine.wait_for_text("SOME-NODE")
    machine.wait_for_text("${pkgs.tsm-client.passthru.unwrapped.version}")

    machine.shutdown()
  '';

  meta.maintainers = [ lib.maintainers.yarny ];
})
