{ pkgs, ... }:
{
  name = "ghostfolio";

  nodes.machine = {
    services.ghostfolio = {
      enable = true;
      environmentFiles = [
        (pkgs.writeText "ghostfolio-test.env" ''
          JWT_SECRET_KEY=test-jwt-secret
          ACCESS_TOKEN_SALT=test-access-token-salt
        '')
      ];
    };
  };

  testScript =
    { nodes, ... }:
    let
      port = nodes.machine.services.ghostfolio.settings.PORT;
    in
    ''
      machine.wait_for_unit("ghostfolio.service")
      machine.wait_for_open_port(${toString port})
      machine.succeed("curl --fail http://127.0.0.1:${toString port}/api/v1/health")
    '';
}
