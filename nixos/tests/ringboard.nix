{
  config,
  pkgs,
  lib,
  ...
}:
{
  name = "ringboard";
  meta.maintainers = pkgs.ringboard.meta.maintainers ++ (with lib.maintainers; [ h7x4 ]);

  nodes.machine = {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    test-support.displayManager.auto.user = "alice";

    services.xserver.displayManager.sessionCommands = ''
      '${lib.getExe pkgs.gedit}' my_document &
    '';

    services.ringboard.x11.enable = true;
  };

  enableOCR = true;

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.test-support.displayManager.auto) user;
    in
    ''
      @polling_condition
      def gedit_running():
        "Check that gedit is running and visible to the user"
        machine.wait_for_text("my_document")

      with subtest("Wait for service startup"):
        machine.wait_for_unit("graphical.target")
        machine.wait_for_unit("ringboard-server.service", "${user}")
        machine.wait_for_unit("ringboard-listener.service", "${user}")

      with subtest("Ensure clipboard is monitored"):
        with gedit_running: # type: ignore[union-attr]
          machine.send_chars("Hello world!", delay=0.1)
          machine.sleep(1)
          machine.send_key("ctrl-a")
          machine.sleep(1)
          machine.send_key("ctrl-c")
        machine.wait_until_succeeds("su - '${user}' -c 'journalctl --user -u ringboard-listener.service --grep \'Small selection transfer complete\'''", timeout=60)
        machine.succeed("su - '${user}' -c 'ringboard search Hello | grep world!'")
    '';
}
