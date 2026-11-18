{ lib, pkgs, ... }:
let
  settings = (pkgs.formats.json { }).generate "settings.json" {
    search_shortcut = "Ctrl+L";
    launch_at_startup = true;
  };
in
{
  name = "proton-lumo";
  meta.maintainers = with lib.maintainers; [ WitteShadovv ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      test-support.displayManager.auto.user = "alice";
      # Lets the test driver inspect alice's display
      environment.variables.XAUTHORITY = "${config.users.users.alice.home}/.Xauthority";

      environment.systemPackages = [
        pkgs.proton-lumo
        pkgs.xdg-utils
        # Logs every connection, so an update check is noticed before any TLS
        (pkgs.writers.writePython3Bin "connection-logger" { } ''
          import socket
          import sys

          server = socket.create_server(("127.0.0.1", int(sys.argv[1])))
          print("listening", flush=True)
          while True:
              conn, _ = server.accept()
              print("connection", flush=True)
              conn.close()
        '')
      ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("Lumo starts and loads the production web app"):
        # Stand-in update server that the disabled in-app updater must never contact.
        # wait_for_open_port would connect to it, so wait for its own message instead.
        machine.succeed("connection-logger 8443 >/tmp/update-checks.log 2>&1 &")
        machine.wait_until_succeeds("grep -q listening /tmp/update-checks.log")
        machine.succeed(
            "su - alice -c 'install -D -m 644 ${settings} ~/.config/me.proton.lumo-app/settings.json'"
        )
        # https, because release builds refuse plain http update servers without connecting
        machine.succeed(
            "su - alice -c 'DISPLAY=:0 LUMO_UPDATE_MANIFEST_URL=https://127.0.0.1:8443/latest.json lumo-desktop >&2 &'"
        )
        # The startup update check runs before the window is shown
        machine.wait_for_window("Lumo: Your Private AI Assistant")
        # The VM is offline, so WebKit reports that it cannot resolve the host
        machine.wait_for_text("lumo.proton.me")
        machine.screenshot("proton-lumo")

    with subtest("The in-app updater never checks for updates"):
        machine.fail("grep connection /tmp/update-checks.log")
        # Connections are logged, so the check above is meaningful
        machine.execute("curl -s -m 5 https://127.0.0.1:8443/")
        machine.wait_until_succeeds("grep -q connection /tmp/update-checks.log")

    with subtest("Launch at startup runs the wrapper from PATH"):
        machine.wait_for_file("/home/alice/.config/autostart/lumo.desktop")
        machine.succeed("grep -qE '^Exec=lumo-desktop *$' /home/alice/.config/autostart/lumo.desktop")

    with subtest("Lumo handles the sign-in callback scheme"):
        machine.succeed(
            "su - alice -c 'xdg-mime query default x-scheme-handler/proton-lumo' | grep -Fx lumo.desktop"
        )
  '';
}
