# Run this test with NIXPKGS_ALLOW_UNFREE=1
{ lib, ... }:
{
  name = "checkmate-server";
  meta.maintainers = with lib.maintainers; [ robertjakub ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.mongodb.package = pkgs.mongodb-ce;

      services.checkmate-server = {
        enable = true;
        vhostName = "default";
        enableLocalDB = true;
        settings = {
          logLevel = "info";
          clientHost = "http://127.0.0.1";
          JWTSecretFile = "/run/checkmate-jwt";
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
      };

    };

  testScript = ''
    machine.start()

    machine.execute("echo \"JWTSecret\" > /run/checkmate-jwt && chmod 400 /run/checkmate-jwt")
    machine.wait_for_unit("checkmate-backend.service")
    machine.wait_for_open_port(52345)

    machine.wait_until_succeeds("journalctl -o cat -u checkmate-backend.service | grep 'Server started on port:52345'")

    machine.succeed("curl -sSfN http://127.0.0.1:52345/ | grep \"<title>Checkmate</title>\"")
    machine.succeed("curl -sSfN http://127.0.0.1:52345/api-docs/ | grep \"<title>Swagger UI</title>\"")
    machine.succeed("curl -sSfN http://127.0.0.1/ | grep \"<title>Checkmate</title>\"")
    machine.succeed("curl -sSfN http://127.0.0.1/api-docs/ | grep \"<title>Swagger UI</title>\"")

    machine.shutdown()
  '';

}
