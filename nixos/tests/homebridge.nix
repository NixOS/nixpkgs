{
  lib,
  ...
}:

let
  userStoragePath = "/var/lib/foobar";
  pluginPath = "${userStoragePath}/node_modules";
in
{
  name = "homebridge";
  meta.maintainers = with lib.maintainers; [ fmoda3 ];

  nodes.homebridge =
    { pkgs, ... }:
    {
      services.homebridge = {
        enable = true;
        inherit userStoragePath pluginPath;

        settings = {
          bridge = {
            name = "Homebridge";
            port = 51826;
          };
        };

        uiSettings = {
          port = 8581;
        };
      };

      # Cause a configuration change inside `config.json` and verify that the process is being reloaded.
      specialisation.differentName = {
        inheritParentConfig = true;
        configuration.services.homebridge.settings.bridge.name = lib.mkForce "Test Home";
      };
    };

  testScript =
    { nodes, ... }:
    let
      system = nodes.homebridge.system.build.toplevel;
    in
    ''
      import json

      start_all()


      def get_homebridge_journal_cursor() -> str:
          exit, out = homebridge.execute("journalctl -u homebridge.service -n1 -o json-pretty --output-fields=__CURSOR")
          assert exit == 0
          return json.loads(out)["__CURSOR"]


      def get_homebridge_ui_journal_cursor() -> str:
          exit, out = homebridge.execute("journalctl -u homebridge-config-ui-x.service -n1 -o json-pretty --output-fields=__CURSOR")
          assert exit == 0
          return json.loads(out)["__CURSOR"]


      def wait_for_homebridge(cursor):
          homebridge.wait_until_succeeds(f"journalctl --after-cursor='{cursor}' -u homebridge.service | grep -q 'is running on port'")


      def wait_for_homebridge_ui(cursor):
          homebridge.wait_until_succeeds(f"journalctl --after-cursor='{cursor}' -u homebridge-config-ui-x.service | grep -q 'is listening on'")


      homebridge.wait_for_unit("homebridge.service")
      homebridge.wait_for_unit("homebridge-config-ui-x.service")
      homebridge_cursor = get_homebridge_journal_cursor()
      homebridge_ui_cursor = get_homebridge_ui_journal_cursor()

      with subtest("Check that JSON configuration file is in place"):
          homebridge.succeed("test -f ${userStoragePath}/config.json")

      with subtest("Check that Homebridge's web interface and API can be reached"):
          wait_for_homebridge(homebridge_cursor)
          wait_for_homebridge_ui(homebridge_ui_cursor)
          homebridge.wait_for_open_port(51826)
          homebridge.wait_for_open_port(8581)
          homebridge.succeed("curl --fail http://localhost:8581/")

      with subtest("Check service restart from SIGHUP"):
          homebridge_pid = homebridge.succeed("systemctl show --property=MainPID homebridge.service")
          homebridge_ui_pid = homebridge.succeed("systemctl show --property=MainPID homebridge-config-ui-x.service")
          homebridge_cursor = get_homebridge_journal_cursor()
          homebridge_ui_cursor = get_homebridge_ui_journal_cursor()
          homebridge.succeed("${system}/specialisation/differentName/bin/switch-to-configuration test")
          wait_for_homebridge(homebridge_cursor)
          wait_for_homebridge_ui(homebridge_ui_cursor)
          new_homebridge_pid = homebridge.succeed("systemctl show --property=MainPID homebridge.service")
          new_homebridge_ui_pid = homebridge.succeed("systemctl show --property=MainPID homebridge-config-ui-x.service")
          assert homebridge_pid != new_homebridge_pid, "The PID of the homebridge process must change after sending SIGHUP"
          assert homebridge_ui_pid != new_homebridge_ui_pid, "The PID of the homebridge ui process must change after sending SIGHUP"

      with subtest("Check that no errors were logged"):
          homebridge.fail("journalctl -u homebridge -o cat | grep -q ERROR")
          homebridge.fail("journalctl -u homebridge-config-ui-x -o cat | grep -q ERROR")

      with subtest("Check systemd unit hardening"):
          homebridge.log(homebridge.succeed("systemctl cat homebridge.service"))
          homebridge.log(homebridge.succeed("systemd-analyze security homebridge.service"))
          homebridge.log(homebridge.succeed("systemctl cat homebridge-config-ui-x.service"))
          homebridge.log(homebridge.succeed("systemd-analyze security homebridge-config-ui-x.service"))
    '';
}
