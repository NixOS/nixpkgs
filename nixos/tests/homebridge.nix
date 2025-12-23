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


      def wait_for_homebridge(cursor):
          homebridge.wait_until_succeeds(f"journalctl --after-cursor='{cursor}' -u homebridge.service | grep -q 'Logging to'")


      homebridge.wait_for_unit("homebridge.service")
      homebridge_cursor = get_homebridge_journal_cursor()

      with subtest("Check that JSON configuration file is in place"):
          homebridge.succeed("test -f ${userStoragePath}/config.json")

      with subtest("Check that Homebridge's web interface and API can be reached"):
          wait_for_homebridge(homebridge_cursor)
          homebridge.wait_for_open_port(51826)
          homebridge.wait_for_open_port(8581)
          homebridge.succeed("curl --fail http://localhost:8581/")

      with subtest("Check service restart from SIGHUP"):
          homebridge_pid = homebridge.succeed("systemctl show --property=MainPID homebridge.service")
          homebridge_cursor = get_homebridge_journal_cursor()
          homebridge.succeed("${system}/specialisation/differentName/bin/switch-to-configuration test")
          wait_for_homebridge(homebridge_cursor)
          new_homebridge_pid = homebridge.succeed("systemctl show --property=MainPID homebridge.service")
          assert homebridge_pid != new_homebridge_pid, "The PID of the homebridge process must change after sending SIGHUP"

      with subtest("Check that no errors were logged"):
          homebridge.fail("journalctl -u homebridge -o cat | grep -q ERROR")

      with subtest("Check systemd unit hardening"):
          homebridge.log(homebridge.succeed("systemctl cat homebridge.service"))
          homebridge.log(homebridge.succeed("systemd-analyze security homebridge.service"))
    '';
}
