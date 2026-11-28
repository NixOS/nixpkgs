{ lib, ... }: {
  name = "lidarr";
  meta.maintainers = with lib.maintainers; [ connor-grady ];

  nodes.machine = {
    services.lidarr = {
      enable = true;
      settings.auth.apikey = "0123456789abcdef0123456789abcdef";
    };
  };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.lidarr;
    in
    ''
      import json

      machine.wait_for_unit("lidarr.service")
      machine.wait_for_open_port(${toString cfg.settings.server.port})
      machine.wait_until_succeeds("curl --fail http://localhost:${toString cfg.settings.server.port}/")

      with subtest("ping reports a healthy database"):
          ping = json.loads(machine.succeed("curl --fail http://localhost:${toString cfg.settings.server.port}/ping"))
          assert ping["status"] == "OK", ping

      with subtest("system status reports the packaged version"):
          status = json.loads(machine.succeed("curl --fail --header 'X-Api-Key: ${cfg.settings.auth.apikey}' http://localhost:${toString cfg.settings.server.port}/api/v1/system/status"))
          assert status["version"] == "${cfg.package.versionForDotnet}", status
    '';
}
