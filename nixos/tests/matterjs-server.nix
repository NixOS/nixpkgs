{ pkgs, ... }:

{
  name = "matterjs-server";
  meta = {
    inherit (pkgs.matterjs-server.meta) maintainers;
  };

  containers.machine.services.matterjs-server.enable = true;

  testScript =
    { containers, ... }:
    let
      inherit (containers.machine.services.matterjs-server) listenAddress port package;
    in
    ''
      import json

      machine.wait_for_unit("matterjs-server.service")
      machine.wait_for_open_port(${toString port})

      health = json.loads(machine.succeed("curl -fsS http://${listenAddress}:${toString port}/health"))
      assert health["version"] == "${package.version}"
    '';
}
