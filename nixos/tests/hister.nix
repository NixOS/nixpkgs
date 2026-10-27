{ lib, pkgs, ... }:
let
  configPathConfig = pkgs.writeText "hister-config.yml" ''
    app:
      title: NixOS Hister Config Path
      search_url: https://config.example.invalid/?q={query}
    hotkeys:
      web:
        alt+c: open_query_in_search_engine
  '';
in
{
  name = "hister";

  meta = {
    maintainers = with lib.maintainers; [ _4evy ];
  };

  nodes.machine = {
    environment.systemPackages = [ pkgs.jq ];

    systemd.tmpfiles.settings."10-hister-env"."/run/hister.env"."f" = {
      mode = "0600";
      user = "root";
      group = "root";
      argument = "HISTER__APP__ACCESS_TOKEN=test-token";
    };

    specialisation = {
      inline_settings.configuration.services.hister = {
        enable = true;
        port = 4433;
        environmentFile = "/run/hister.env";
        settings = {
          app = {
            log_level = "debug";
            title = "NixOS Hister";
            search_url = "https://search.example.invalid/?q={query}";
            open_results_on_new_tab = true;
          };
          hotkeys.web."alt+n" = "open_query_in_search_engine";
        };
      };

      config_file.configuration.services.hister = {
        enable = true;
        port = 4434;
        configPath = configPathConfig;
      };

      custom_data_dir.configuration.services.hister = {
        enable = true;
        port = 4435;
        dataDir = "/srv/hister-data";
        settings.app.title = "NixOS Hister Custom Data";
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
        machine.systemctl("restart hister.service")
        machine.wait_for_unit("hister.service")
        machine.wait_for_open_port(4433)
        machine.succeed("curl -fsS http://localhost:4433/ | grep -F '<title>Hister</title>'")
        machine.succeed("test $(stat -c %a /var/lib/hister) = 750")
        machine.succeed("test $(stat -c %a /run/hister) = 750")
        machine.succeed("test -s /run/hister/tui.yaml")
        machine.succeed("test -s /var/lib/hister/db.sqlite3")
        machine.succeed("test -s /var/lib/hister/.secret_key")
        machine.succeed("test -s /var/lib/hister/rules.json")
        machine.succeed(
            "curl -fsS http://localhost:4433/api/config"
            + " | jq -e "
            + "'"
            + '.baseUrl == "http://127.0.0.1:4433"'
            + ' and .title == "NixOS Hister"'
            + ' and .searchUrl == "https://search.example.invalid/?q={query}"'
            + ' and .openResultsOnNewTab == true'
            + ' and .hotkeys."alt+n" == "open_query_in_search_engine"'
            + ' and .authMode == "token"'
            + "'"
        )
        machine.fail("journalctl -u hister.service | grep -F 'Failed to create tui.yaml'")

      with subtest("configPath"):
        machine.succeed("${switchTo "config_file"}")
        machine.systemctl("restart hister.service")
        machine.wait_for_unit("hister.service")
        machine.wait_for_open_port(4434)
        machine.succeed("curl -fsS http://localhost:4434/ >/dev/null")
        machine.succeed("test $(stat -c %a /run/hister) = 750")
        machine.succeed("test -s /run/hister/tui.yaml")
        machine.succeed("test -s /var/lib/hister/db.sqlite3")
        machine.succeed("test -s /var/lib/hister/.secret_key")
        machine.succeed("test -s /var/lib/hister/rules.json")
        machine.succeed(
            "curl -fsS http://localhost:4434/api/config"
            + " | jq -e "
            + "'"
            + '.baseUrl == "http://127.0.0.1:4434"'
            + ' and .title == "NixOS Hister Config Path"'
            + ' and .searchUrl == "https://config.example.invalid/?q={query}"'
            + ' and .hotkeys."alt+c" == "open_query_in_search_engine"'
            + ' and .authMode == "none"'
            + "'"
        )
        machine.fail("journalctl -u hister.service | grep -F 'Failed to create tui.yaml'")

      with subtest("custom dataDir"):
        machine.systemctl("stop hister.service")
        machine.succeed("rm -rf /var/lib/hister")
        machine.succeed("${switchTo "custom_data_dir"}")
        machine.systemctl("restart hister.service")
        machine.wait_for_unit("hister.service")
        machine.wait_for_open_port(4435)
        machine.succeed("curl -fsS http://localhost:4435/ >/dev/null")
        machine.succeed("test $(stat -c %U:%G:%a /srv/hister-data) = hister:hister:750")
        machine.succeed("test $(stat -c %a /run/hister) = 750")
        machine.succeed("test -s /run/hister/tui.yaml")
        machine.succeed("test -s /srv/hister-data/db.sqlite3")
        machine.succeed("test -s /srv/hister-data/.secret_key")
        machine.succeed("test -s /srv/hister-data/rules.json")
        machine.succeed("test ! -e /var/lib/hister")
        machine.succeed(
            "curl -fsS http://localhost:4435/api/config"
            + " | jq -e "
            + "'"
            + '.baseUrl == "http://127.0.0.1:4435"'
            + ' and .title == "NixOS Hister Custom Data"'
            + ' and .authMode == "none"'
            + "'"
        )
        machine.fail("journalctl -u hister.service | grep -F 'Failed to create tui.yaml'")
    '';
}
