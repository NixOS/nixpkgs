{ ... }:
{
  name = "ghostfolio";

  nodes.machine = {
    services.ghostfolio = {
      enable = true;
      settings = {
        JWT_SECRET_KEY = "test-jwt-secret";
        ACCESS_TOKEN_SALT = "test-access-token-salt";
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("ghostfolio.service")
    machine.wait_for_open_port(3333)
    machine.succeed("curl --fail http://127.0.0.1:3333/api/v1/health")
  '';
}
