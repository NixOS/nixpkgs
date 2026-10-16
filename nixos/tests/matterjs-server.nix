{ lib, ... }:

{
  name = "matterjs-server";
  meta.maintainers = with lib.maintainers; [ kranzes ];

  nodes.machine.services.matterjs-server.enable = true;

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services.matterjs-server) listenAddress port package;
    in
    ''
      import json

      machine.wait_for_unit("matterjs-server.service")
      machine.wait_for_open_port(${toString port})

      health = json.loads(machine.succeed("curl -fsS http://${listenAddress}:${toString port}/health"))
      assert health["version"] == "${package.version}"
    '';
}
