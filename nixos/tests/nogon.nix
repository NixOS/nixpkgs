{ lib, pkgs, ... }:
let
  configPathConfig = pkgs.writeText "nogon-config.yml" ''
    app:
      title: NixOS Nogon Config Path
      search_url: https://config.example.invalid/?q={query}
    hotkeys:
      web:
        alt+c: open_query_in_search_engine
  '';
in
{
  name = "nogon";

  meta = {
    maintainers = with lib.maintainers; [ _4evy ];
  };

  nodes.machine = {
    environment.systemPackages = [ pkgs.jq ];

    systemd.tmpfiles.settings = {
      "10-nogon-env"."/run/nogon.env"."f" = {
        mode = "0600";
        user = "root";
        group = "root";
        argument = "NOGON__APP__ACCESS_TOKEN=test-token";
      };
      "10-hister-env"."/run/hister.env"."f" = {
        mode = "0600";
        user = "root";
        group = "root";
        argument = "HISTER__APP__ACCESS_TOKEN=legacy-token";
      };
    };

    specialisation = {
      inline_settings.configuration.services.nogon = {
        enable = true;
        port = 4433;
        environmentFile = "/run/nogon.env";
        settings = {
          app = {
            log_level = "debug";
            title = "NixOS Nogon";
            search_url = "https://search.example.invalid/?q={query}";
            open_results_on_new_tab = true;
          };
          hotkeys.web."alt+n" = "open_query_in_search_engine";
        };
      };

      config_file.configuration.services.nogon = {
        enable = true;
        port = 4434;
        configPath = configPathConfig;
      };

      custom_data_dir.configuration.services.nogon = {
        enable = true;
        port = 4435;
        dataDir = "/srv/nogon-data";
        settings.app.title = "NixOS Nogon Custom Data";
      };

      legacy_hister.configuration = {
        system.stateVersion = "26.11";
        services.hister = {
          enable = true;
          port = 4436;
          environmentFile = "/run/hister.env";
          settings.app.title = "NixOS Legacy Hister";
        };
      };

      legacy_nogon.configuration = {
        system.stateVersion = "26.11";
        services.nogon = {
          enable = true;
          port = 4436;
          environmentFile = "/run/hister.env";
          settings.app.title = "NixOS Legacy Nogon";
        };
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      switchTo =
        name:
        "${nodes.machine.system.build.toplevel}/specialisation/${name}/bin/switch-to-configuration test";
    in
    ''
      start_all()

      with subtest("inline settings"):
        machine.succeed("${switchTo "inline_settings"}")
        machine.systemctl("restart nogon.service")
        machine.wait_for_unit("nogon.service")
        machine.wait_for_open_port(4433)
        machine.succeed("curl -fsS http://localhost:4433/ | grep -F '<title>Nogon</title>'")
        machine.succeed("test $(stat -c %a /var/lib/nogon) = 750")
        machine.succeed("test $(stat -c %U:%G /var/lib/nogon) = nogon:nogon")
        machine.succeed("test $(stat -c %a /run/nogon) = 750")
        machine.succeed("test -s /run/nogon/tui.yaml")
        machine.succeed("test -s /var/lib/nogon/db.sqlite3")
        machine.succeed("test -s /var/lib/nogon/.secret_key")
        machine.succeed("test -s /var/lib/nogon/rules.json")
        machine.succeed(
            "curl -fsS http://localhost:4433/api/config"
            + " | jq -e "
            + "'"
            + '.baseUrl == "http://127.0.0.1:4433"'
            + ' and .title == "NixOS Nogon"'
            + ' and .searchUrl == "https://search.example.invalid/?q={query}"'
            + ' and .openResultsOnNewTab == true'
            + ' and .hotkeys."alt+n" == "open_query_in_search_engine"'
            + ' and .authMode == "token"'
            + "'"
        )
        machine.fail("journalctl -u nogon.service | grep -F 'Failed to create tui.yaml'")

      with subtest("configPath"):
        machine.succeed("${switchTo "config_file"}")
        machine.systemctl("restart nogon.service")
        machine.wait_for_unit("nogon.service")
        machine.wait_for_open_port(4434)
        machine.succeed("curl -fsS http://localhost:4434/ >/dev/null")
        machine.succeed("test $(stat -c %a /run/nogon) = 750")
        machine.succeed("test -s /run/nogon/tui.yaml")
        machine.succeed("test -s /var/lib/nogon/db.sqlite3")
        machine.succeed("test -s /var/lib/nogon/.secret_key")
        machine.succeed("test -s /var/lib/nogon/rules.json")
        machine.succeed(
            "curl -fsS http://localhost:4434/api/config"
            + " | jq -e "
            + "'"
            + '.baseUrl == "http://127.0.0.1:4434"'
            + ' and .title == "NixOS Nogon Config Path"'
            + ' and .searchUrl == "https://config.example.invalid/?q={query}"'
            + ' and .hotkeys."alt+c" == "open_query_in_search_engine"'
            + ' and .authMode == "none"'
            + "'"
        )
        machine.fail("journalctl -u nogon.service | grep -F 'Failed to create tui.yaml'")

      with subtest("custom dataDir"):
        machine.systemctl("stop nogon.service")
        machine.succeed("rm -rf /var/lib/nogon")
        machine.succeed("${switchTo "custom_data_dir"}")
        machine.systemctl("restart nogon.service")
        machine.wait_for_unit("nogon.service")
        machine.wait_for_open_port(4435)
        machine.succeed("curl -fsS http://localhost:4435/ >/dev/null")
        machine.succeed("test $(stat -c %U:%G:%a /srv/nogon-data) = nogon:nogon:750")
        machine.succeed("test $(stat -c %a /run/nogon) = 750")
        machine.succeed("test -s /run/nogon/tui.yaml")
        machine.succeed("test -s /srv/nogon-data/db.sqlite3")
        machine.succeed("test -s /srv/nogon-data/.secret_key")
        machine.succeed("test -s /srv/nogon-data/rules.json")
        machine.succeed("test ! -e /var/lib/nogon")
        machine.succeed(
            "curl -fsS http://localhost:4435/api/config"
            + " | jq -e "
            + "'"
            + '.baseUrl == "http://127.0.0.1:4435"'
            + ' and .title == "NixOS Nogon Custom Data"'
            + ' and .authMode == "none"'
            + "'"
        )
        machine.fail("journalctl -u nogon.service | grep -F 'Failed to create tui.yaml'")

      with subtest("legacy services.hister and stateVersion compatibility"):
        machine.succeed("${switchTo "legacy_hister"}")
        machine.wait_for_unit("nogon.service")
        machine.wait_for_open_port(4436)
        machine.succeed("nogon --version | grep -F 'nogon version'")
        machine.succeed("hister --version | grep -F 'nogon version'")
        machine.succeed("systemctl is-active nogon.service")
        machine.succeed("systemctl is-active hister.service")
        machine.succeed("test $(stat -c %U:%G:%a /var/lib/hister) = hister:hister:750")
        machine.succeed("test -s /var/lib/hister/db.sqlite3")
        machine.succeed("test ! -e /var/lib/nogon")
        machine.succeed(
            "curl -fsS http://localhost:4436/api/config"
            + " | jq -e "
            + "'"
            + '.title == "NixOS Legacy Hister"'
            + ' and .authMode == "token"'
            + "'"
        )
        secret_before = machine.succeed("cat /var/lib/hister/.secret_key")
        machine.succeed(
            "curl -fsS -X POST http://127.0.0.1:4436/api/add"
            + " -H 'Origin: hister://'"
            + " -H 'Content-Type: application/json'"
            + " -H 'X-Access-Token: legacy-token'"
            + " -d '{\"url\":\"https://example.org/legacy\",\"title\":\"LegacyEntry\",\"text\":\"legacy_persistence_token\"}'"
        )
        machine.succeed(
            "hister -u http://127.0.0.1:4436 -t legacy-token search legacy_persistence_token"
            + " | grep -F 'LegacyEntry'"
        )

      with subtest("switching from services.hister to services.nogon preserves hister state"):
        machine.succeed("${switchTo "legacy_nogon"}")
        machine.wait_for_unit("nogon.service")
        machine.wait_for_open_port(4436)
        machine.succeed("systemctl is-active hister.service")
        machine.succeed("test $(stat -c %U:%G:%a /var/lib/hister) = hister:hister:750")
        machine.succeed("test ! -e /var/lib/nogon")
        assert machine.succeed("cat /var/lib/hister/.secret_key") == secret_before
        machine.succeed(
            "curl -fsS http://localhost:4436/api/config"
            + " | jq -e "
            + "'"
            + '.title == "NixOS Legacy Nogon"'
            + ' and .authMode == "token"'
            + "'"
        )
        machine.succeed(
            "nogon -u http://127.0.0.1:4436 -t legacy-token search legacy_persistence_token"
            + " | grep -F 'LegacyEntry'"
        )
    '';
}
