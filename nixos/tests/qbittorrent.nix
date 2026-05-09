{ pkgs, lib, ... }:
{
  name = "qbittorrent";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      fsnkty
      undefined-landmark
    ];
  };

  nodes = {
    simple = {
      services.qbittorrent.enable = true;

      specialisation.portChange.configuration = {
        services.qbittorrent = {
          enable = true;
          webuiPort = 5555;
          torrentingPort = 44444;
        };
      };

      specialisation.openPorts.configuration = {
        services.qbittorrent = {
          enable = true;
          openFirewall = true;
          webuiPort = 8080;
          torrentingPort = 55555;
        };
      };

      specialisation.serverConfig.configuration = {
        services.qbittorrent = {
          enable = true;
          webuiPort = null;
          serverConfig.Preferences.WebUI.Port = "8181";
        };
      };
    };
    # Seperate vm because it's not possible to reboot into a specialisation with
    # switch-to-configuration: https://github.com/NixOS/nixpkgs/issues/82851
    # For one of the test we check if manual changes are overridden during
    # reboot, therefore it's necessary to reboot into a declarative setup.
    declarative = {
      services.qbittorrent = {
        enable = true;
        webuiPort = null;
        serverConfig = {
          Preferences = {
            WebUI = {
              Username = "user";
              # Default password: adminadmin
              Password_PBKDF2 = "@ByteArray(6DIf26VOpTCYbgNiO6DAFQ==:e6241eaAWGzRotQZvVA5/up9fj5wwSAThLgXI2lVMsYTu1StUgX9MgmElU3Sa/M8fs+zqwZv9URiUOObjqJGNw==)";
              Port = lib.mkDefault "8181";
            };
          };
        };
      };

      specialisation.serverConfigChange.configuration = {
        services.qbittorrent = {
          enable = true;
          webuiPort = null;
          serverConfig.Preferences.WebUI.Port = "7171";
        };
      };

      # Verify fix for https://github.com/NixOS/nixpkgs/issues/516998:
      # A non-empty serverConfig must not cause qBittorrent to inject extra
      # entries from its changedDefaults[] legacy table beyond what we seed.
      specialisation.legacyDefaultsBlocked.configuration = {
        services.qbittorrent = {
          enable = true;
          webuiPort = null;
          serverConfig.LegalNotice.Accepted = true;
          # QueueingSystemEnabled is intentionally NOT set here;
          # the module seeds mkDefault false to block legacy injection.
        };
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      simpleSpecPath = "${nodes.simple.system.build.toplevel}/specialisation";
      declarativeSpecPath = "${nodes.declarative.system.build.toplevel}/specialisation";
      portChange = "${simpleSpecPath}/portChange";
      openPorts = "${simpleSpecPath}/openPorts";
      serverConfig = "${simpleSpecPath}/serverConfig";
      serverConfigChange = "${declarativeSpecPath}/serverConfigChange";
      legacyDefaultsBlocked = "${declarativeSpecPath}/legacyDefaultsBlocked";
    in
    ''
      simple.start(allow_reboot=True)
      declarative.start(allow_reboot=True)


      def test_webui(machine, port):
          machine.wait_for_unit("qbittorrent.service")
          machine.wait_for_open_port(port)
          machine.wait_until_succeeds(f"curl --fail http://localhost:{port}")


      # To simulate an interactive change in the settings
      def setPreferences_api(machine, port, post_creds, post_data):
          qb_url = f"http://localhost:{port}"
          api_url = f"{qb_url}/api/v2"
          cookie_path = "/tmp/qbittorrent.cookie"

          machine.succeed(
              f'curl --header "Referer: {qb_url}" \
              --data "{post_creds}" {api_url}/auth/login \
              -c {cookie_path}'
          )
          machine.succeed(
              f'curl --header "Referer: {qb_url}" \
              --data "{post_data}" {api_url}/app/setPreferences \
              -b {cookie_path}'
          )


      # A randomly generated password is printed in the service log when no
      # password it set
      def get_temp_pass(machine):
          _, password = machine.execute(
              "journalctl -u qbittorrent.service |\
              grep 'The WebUI administrator password was not set.' |\
              awk '{ print $NF }' | tr -d '\n'"
          )
          return password


      # Non declarative tests

      with subtest("webui works with all default settings"):
          test_webui(simple, 8080)

      with subtest("check if manual changes in settings are saved correctly"):
          temp_pass = get_temp_pass(simple)

          ## Change some settings
          api_post = [r"json={\"listen_port\": 33333}", r"json={\"web_ui_port\": 9090}"]
          for x in api_post:
              setPreferences_api(
                  machine=simple,
                  port=8080,
                  post_creds=f"username=admin&password={temp_pass}",
                  post_data=x,
              )

          simple.wait_for_open_port(33333)
          test_webui(simple, 9090)

          ## Test which settings are reset
          ## As webuiPort is passed as an cli it should reset after reboot
          ## As torrentingPort is not passed as an cli it should not reset after
          ## reboot
          simple.reboot()
          test_webui(simple, 8080)
          simple.wait_for_open_port(33333)

      with subtest("ports are changed on config change"):
          simple.succeed("${portChange}/bin/switch-to-configuration test")
          test_webui(simple, 5555)
          simple.wait_for_open_port(44444)

      with subtest("firewall is opened correctly"):
          simple.succeed("${openPorts}/bin/switch-to-configuration test")
          test_webui(simple, 8080)
          declarative.wait_until_succeeds("curl --fail http://simple:8080")
          declarative.wait_for_open_port(55555, "simple")

      with subtest("switching from simple to declarative works"):
          simple.succeed("${serverConfig}/bin/switch-to-configuration test")
          test_webui(simple, 8181)


      # Declarative tests

      with subtest("serverConfig is applied correctly"):
          test_webui(declarative, 8181)

      with subtest("manual changes are overridden during reboot"):
          ## Change some settings
          setPreferences_api(
              machine=declarative,
              port=8181, # as set through serverConfig
              post_creds="username=user&password=adminadmin",
              post_data=r"json={\"web_ui_port\": 9191}",
          )

          test_webui(declarative, 9191)

          ## Test which settings are reset
          ## The generated qBittorrent.conf is, apparently, reapplied after reboot.
          ## Because the port is set in `serverConfig` this overrides the manually
          ## set port.
          declarative.reboot()
          test_webui(declarative, 8181)

      with subtest("changes in serverConfig are applied correctly"):
          declarative.succeed("${serverConfigChange}/bin/switch-to-configuration test")
          test_webui(declarative, 7171)

      with subtest("legacy defaults are blocked when serverConfig is non-empty"):
          # Differential test for https://github.com/NixOS/nixpkgs/issues/516998.
          # The bug: qBittorrent detects a non-empty on-disk config at startup,
          # activates "legacy mode", and injects changedDefaults[] values (e.g.
          # QueueingSystemEnabled=true) regardless of the current upstream default.
          # The fix: the module pre-seeds those values via mkDefault so qBittorrent
          # sees them already present and does not inject legacy overrides.
          #
          # Baseline (fresh install): restart simple with a clean config so qBit
          # writes only its current defaults with no legacy mode activated.
          simple.stop_job("qbittorrent.service")
          simple.succeed("rm -f /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf")
          simple.start_job("qbittorrent.service")
          simple.wait_for_unit("qbittorrent.service")
          simple.wait_until_succeeds(
              "test -s /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf"
          )
          fresh_conf = simple.succeed(
              "cat /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf"
          )

          # Declarative install: switch to a config that has a non-empty serverConfig
          # (only LegalNotice.Accepted is set; QueueingSystemEnabled is intentionally
          # absent so the module's mkDefault seed is the only source of that key).
          declarative.succeed("${legacyDefaultsBlocked}/bin/switch-to-configuration test")
          declarative.wait_for_unit("qbittorrent.service")
          seeded_conf = declarative.succeed(
              "cat /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf"
          )

          # Differential assertion: the legacy-mode bug would make QueueingSystemEnabled
          # appear as true only in seeded_conf (non-empty on-disk config path) but not
          # in fresh_conf (fresh install, current defaults). Our seed must prevent that.
          assert "QueueingSystemEnabled=true" not in fresh_conf, (
              "Unexpected: fresh install wrote QueueingSystemEnabled=true\n"
              f"fresh_conf:\n{fresh_conf}"
          )
          assert "QueueingSystemEnabled=true" not in seeded_conf, (
              "Legacy mode was triggered: QueueingSystemEnabled was injected as true.\n"
              f"fresh_conf:\n{fresh_conf}\n\nseeded_conf:\n{seeded_conf}"
          )
    '';
}
