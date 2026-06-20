{ pkgs, ... }:

pkgs.lib.nixosTest {
  name = "robloxapid";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        imports = [ ../modules/services/misc/robloxapid.nix ];

        services.robloxapid.enable = true;

        services.robloxapid.configFile = pkgs.writeText "robloxapid-config.json" ''
          {
            "server": {
              "categoryCheckInterval": "1m",
              "dataRefreshInterval": "30m"
            },
            "wiki": {
              "apiUrl": "https://example.org/api.php",
              "username": "bot",
              "password": "secret",
              "namespace": "Module"
            },
            "dynamicEndpoints": {
              "categoryPrefix": "robloxapid-queue",
              "apiMap": {
                "badges": "https://badges.roblox.com/v1/badges/%s"
              },
              "refreshIntervals": {
                "badges": "30m",
                "about": "1h"
              }
            },
            "openCloud": { "apiKey": "dummy" },
            "roblox": { "cookie": "dummy" }
          }
        '';
      };
  };

  testScript = ''
    start_all();
    machine.wait_for_unit("robloxapid.service");
    machine.succeed("systemctl status robloxapid.service");
  '';
}
