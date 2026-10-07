{
  config,
  getPackage,
  lib,
  ...
}:
let
  package = getPackage config.node.pkgs;
  isV2 = lib.versions.major package.version == "2";
in
{
  name = "whisparr_${lib.versions.major package.version}";
  meta.maintainers = with lib.maintainers; [ connor-grady ];

  nodes.machine = { pkgs, ... }: {
    services.whisparr = {
      enable = true;
      package = getPackage pkgs;
      settings.auth.apikey = lib.mkIf (!isV2) "0123456789abcdef0123456789abcdef";
    };
  };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.whisparr;
    in
    ''
      import json

      machine.wait_for_unit("whisparr.service")
      machine.wait_for_open_port(${toString cfg.settings.server.port})
      machine.wait_until_succeeds("curl --fail http://localhost:${toString cfg.settings.server.port}/")

      with subtest("ping reports a healthy database"):
          ping = json.loads(machine.succeed("curl --fail http://localhost:${toString cfg.settings.server.port}/ping"))
          assert ping["status"] == "OK", ping
    ''
    + lib.optionalString (!isV2) ''
      with subtest("system status reports the packaged version"):
          status = json.loads(machine.succeed("curl --fail --header 'X-Api-Key: ${cfg.settings.auth.apikey}' http://localhost:${toString cfg.settings.server.port}/api/v3/system/status"))
          assert status["version"] == "${cfg.package.versionForDotnet}", status
    '';
}
