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
      # password it set. qBittorrent regenerates this password on every
      # service start, so journalctl can have multiple matching lines —
      # take the most recent.
      def get_temp_pass(machine):
          _, password = machine.execute(
              "journalctl -u qbittorrent.service |\
              grep 'The WebUI administrator password was not set.' |\
              awk 'END { print $NF }' | tr -d '\n'"
          )
          return password


      # Parse a Qt-style INI conf file into a flat dict of full keys to
      # values. Qt joins the section header (e.g. [BitTorrent]) with each
      # in-section key using backslashes, so 'Session\QueueingSystemEnabled'
      # under '[BitTorrent]' is conceptually
      # 'BitTorrent\Session\QueueingSystemEnabled' — which is what
      # qBittorrent's source uses internally and what the differential test
      # below operates on.
      def parse_ini(conf):
          result = {}
          section = ""
          for line in conf.splitlines():
              line = line.strip()
              if not line or line.startswith((";", "#")):
                  continue
              if line.startswith("[") and line.endswith("]"):
                  section = line[1:-1]
              elif "=" in line:
                  key, _, value = line.partition("=")
                  full_key = f"{section}\\{key}" if section else key
                  result[full_key] = value
          return result


      # Differential test for https://github.com/NixOS/nixpkgs/issues/516998.
      #
      # The bug: qBittorrent treats any non-empty on-disk config at first
      # launch as an upgrade from a pre-4.3 install and writes the legacy
      # values from its `changedDefaults[]` table for any keys not already
      # present. Since the NixOS module's ExecStartPre writes the conf
      # before qBittorrent's first launch whenever `serverConfig` is
      # non-empty, every such install hits this.
      #
      # The fix: the module pre-seeds each `changedDefaults[]` entry's
      # current default into the generated config, so qBittorrent sees
      # them as already-present and leaves them alone.
      #
      # The invariant: `changedDefaults[]` entries are written in BOTH the
      # firstTimeUser=true (fresh) and the upgrade() (seeded) paths via
      # `handleChangedDefaults`. With the fix in place, both paths produce
      # the same values for each entry. Without the fix, the seeded path
      # writes the legacy value while fresh writes the current — so any
      # new upstream `changedDefaults[]` entry the module's seed misses
      # surfaces as a value mismatch on a shared key, no enumeration
      # required.
      #
      # Keys written by the upgrade()-only migration logic appear only in
      # seeded (since fresh skips upgrade() entirely) — those are not
      # bug-class, so we don't check "extra in seeded".
      with subtest("legacy default mode is blocked when serverConfig is non-empty"):
          # Wait for each qBit to finish initializing (signaled by its WebUI
          # port opening) and then stop the service. Qt's QSettings only
          # flushes to disk on a periodic timer or on shutdown, so stopping
          # the service is the deterministic way to get a settled conf —
          # SIGTERM triggers `~Application`, which syncs QSettings.
          conf_path = "/var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf"
          simple.wait_for_open_port(8080)
          declarative.wait_for_open_port(8181)
          simple.succeed("systemctl stop qbittorrent.service")
          declarative.succeed("systemctl stop qbittorrent.service")

          fresh = parse_ini(simple.succeed(f"cat {conf_path}"))
          seeded = parse_ini(declarative.succeed(f"cat {conf_path}"))

          # Keys whose values qBittorrent randomizes at first launch.
          # Each instance picks independently, so fresh and seeded
          # legitimately differ here.
          volatile_keys = {
              "BitTorrent\\Session\\Port",
              "BitTorrent\\Session\\SSL\\Port",
          }
          # Keys declarative.serverConfig sets explicitly. fresh has qBit's
          # defaults for these (or doesn't have them at all); seeded has the
          # user-supplied values.
          explicit_keys = {
              "Preferences\\WebUI\\Username",
              "Preferences\\WebUI\\Password_PBKDF2",
              "Preferences\\WebUI\\Port",
          }
          value_mismatches = sorted(
              (k, fresh[k], seeded[k])
              for k in (set(fresh) & set(seeded)) - volatile_keys - explicit_keys
              if fresh[k] != seeded[k]
          )

          if value_mismatches:
              lines = ["Seeded install has values differing from fresh install on keys handleChangedDefaults touches in both paths."]
              lines += [""]
              lines += [f"  {k}: fresh={fv!r}, seeded={sv!r}" for k, fv, sv in value_mismatches]
              lines += [""]
              lines += [
                  "qBittorrent's legacy default mode likely injected an entry from changedDefaults[] that the module's legacyDefaultsSeed doesn't cover.",
                  "Mirror the new entry in modules/services/torrent/qbittorrent.nix:",
                  "https://github.com/qbittorrent/qBittorrent/blob/master/src/app/upgrade.cpp",
              ]
              raise AssertionError("\n".join(lines))

          # Restart both services so the existing subtests below can run
          # against a live qBittorrent.
          simple.succeed("systemctl start qbittorrent.service")
          declarative.succeed("systemctl start qbittorrent.service")


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
    '';
}
