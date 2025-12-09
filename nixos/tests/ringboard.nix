{
  config,
  pkgs,
  lib,
  ...
}:
{
  name = "ringboard";
  meta = { inherit (pkgs.ringboard.meta) maintainers; };

  nodes.machine = {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    test-support.displayManager.auto.user = "alice";

    services.xserver.displayManager.sessionCommands = ''
      '${lib.getExe pkgs.gedit}' &
    '';

    services.ringboard.x11.enable = true;
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.test-support.displayManager.auto) user;
    in
    ''
      @polling_condition
      def gedit_running():
        machine.succeed("pgrep gedit")

      with subtest("Wait for service startup"):
        machine.wait_for_unit("graphical.target")
        machine.wait_for_unit("ringboard-server.service", "${user}")
        machine.wait_for_unit("ringboard-listener.service", "${user}")

      with subtest("Ensure clipboard is monitored"):
        with gedit_running: # type: ignore[union-attr]
          machine.send_chars("Hello world!")
          machine.send_key("ctrl-a")
          machine.send_key("ctrl-c")
          machine.wait_for_console_text("Small selection transfer complete")
          machine.succeed("su - '${user}' -c 'ringboard search Hello | grep world!'")
    '';
}
