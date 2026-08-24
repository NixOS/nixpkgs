{
  lib,
  pkgs,
  database ? "postgres",
  ...
}:
let
  dummyPlugin =
    pkgs.runCommand "nodebb-plugin-nixos-dummy"
      {
        passthru.pluginName = "nodebb-plugin-nixos-dummy";
      }
      ''
        dest=$out/lib/node_modules/nodebb-plugin-nixos-dummy
        mkdir -p "$dest"
        cat > "$dest/package.json" <<'EOF'
        {
          "name": "nodebb-plugin-nixos-dummy",
          "version": "0.0.1",
          "main": "library.js"
        }
        EOF
        cat > "$dest/plugin.json" <<'EOF'
        {
          "id": "nodebb-plugin-nixos-dummy",
          "url": "https://nixos.org",
          "library": "./library.js",
          "hooks": []
        }
        EOF
        printf '%s\n' "'use strict';" "module.exports = {};" > "$dest/library.js"
      '';
in
{
  name = "nodebb-${database}";

  meta = {
    maintainers = with lib.maintainers; [
      lucasew
      prince213
    ];
    teams = [ lib.teams.ngi ];
  };

  nodes.machine = {
    virtualisation.memorySize = 3072;

    environment.systemPackages = [
      pkgs.python3
      pkgs.jq
    ];
    environment.etc."nodebb-api.py".source = ./nodebb-api.py;

    services.nodebb = {
      enable = true;
      package = pkgs.nodebb.withPackages (_: [ dummyPlugin ]);
      database = {
        type = database;
        createLocally = true;
      };
      admin = {
        username = "admin";
        email = "admin@example.com";
        passwordFile = pkgs.writeText "nodebb-admin-password" "nodebb-admin-pass";
      };
      settings.url = "http://localhost:4567";
    };

    services.redis.servers.nodebb.requirePassFile = lib.mkIf (database == "redis") (
      pkgs.writeText "nodebb-redis-password" "nodebb-redis-pass"
    );
  };

  testScript =
    { nodes, ... }:
    let
      port = toString nodes.machine.services.nodebb.settings.port;
      url = nodes.machine.services.nodebb.settings.url;
    in
    ''
      start_all()
      machine.wait_for_unit("nodebb.service")
      machine.wait_for_open_port(${port})

      machine.succeed("test \"$(systemctl show -p NRestarts --value nodebb.service)\" = 0")
      machine.succeed("test \"$(stat -c %a /var/lib/nodebb/config.json)\" = 600")
      machine.fail("journalctl -u nodebb.service | grep -F EACCES")
      machine.fail("journalctl -u nodebb.service | grep -F \"Error executing 'static:app.load'\"")
      machine.fail("journalctl -u nodebb.service | grep -F theme-not-set-in-configuration")

      machine.succeed("curl -sf ${url}/api/v3/ping | grep -q pong")
      machine.succeed("curl -sf ${url}/api/config | grep -q csrf_token")
      machine.succeed("test -f /var/lib/nodebb/.install-hash")
      machine.fail("grep -q nodebb-admin-pass /nix/store/*-config.json")

      machine.succeed("jq -e 'has(\"plugins:active\") | not' /var/lib/nodebb/config.json")
      machine.succeed("jq -e '.plugins.active | index(\"nodebb-plugin-web-push\") == null' /var/lib/nodebb/config.json")
      machine.succeed("jq -e '.plugins.active | index(\"nodebb-theme-harmony\")' /var/lib/nodebb/config.json")
      machine.succeed("jq -e '.plugins.active | index(\"nodebb-plugin-nixos-dummy\")' /var/lib/nodebb/config.json")
      machine.succeed("test -d /var/lib/nodebb/node_modules/nodebb-plugin-nixos-dummy")
      machine.fail("journalctl -u nodebb.service | grep -F 'active but not installed'")

      machine.succeed("jq -e 'has(\"postgres:password\") | not' /var/lib/nodebb/config.json")
      machine.succeed("jq -e 'has(\"redis:password\") | not' /var/lib/nodebb/config.json")
      ${lib.optionalString (database == "postgres") ''
        machine.succeed("jq -e '.postgres.host == \"/run/postgresql\"' /var/lib/nodebb/config.json")
        machine.succeed("jq -e '.postgres | has(\"password\") | not' /var/lib/nodebb/config.json")
      ''}
      ${lib.optionalString (database == "redis") ''
        machine.succeed("jq -e '.redis.password == \"nodebb-redis-pass\"' /var/lib/nodebb/config.json")
        machine.fail("grep -F nodebb-redis-pass /etc/systemd/system/nodebb.service")
      ''}

      machine.succeed("python3 /etc/nodebb-api.py setup")
      machine.succeed("test \"$(journalctl -u nodebb.service | grep -c 'Enabling default theme')\" = 1")

      machine.succeed("systemctl restart nodebb.service")
      machine.wait_for_unit("nodebb.service")
      machine.wait_for_open_port(${port})
      machine.succeed("test \"$(systemctl show -p NRestarts --value nodebb.service)\" = 0")
      machine.succeed("test \"$(journalctl -u nodebb.service | grep -c 'Enabling default theme')\" = 1")
      machine.succeed("python3 /etc/nodebb-api.py persist")
    '';
}
