{ lib, ... }:

{
  name = "relay-server";
  meta.maintainers = with lib.maintainers; [ sweenu ];

  nodes.machine = {
    services.relay-server = {
      enable = true;
    };
  };

  testScript =
    let
      port = 8080;
    in
    ''
      machine.wait_for_unit("relay-server.service")
      machine.wait_for_open_port(${builtins.toString port})
      machine.succeed("curl --fail http://localhost:${builtins.toString port}/ready")
    '';
}
