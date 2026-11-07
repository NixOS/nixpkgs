{ ... }:
{
  name = "koito";

  nodes.machine = {
    services.koito.enable = true;
  };

  testScript =
    { nodes, ... }:
    let
      port = toString nodes.machine.services.koito.environment.KOITO_LISTEN_PORT;
    in
    ''
      machine.wait_for_unit('koito.service')

      machine.wait_for_open_port(${port})
      machine.succeed('curl --fail http://localhost:${port}')
    '';
}
