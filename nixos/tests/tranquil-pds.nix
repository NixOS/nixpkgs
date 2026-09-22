{ lib, ... }:
{
  name = "tranquil-pds";

  nodes.machine =
    { pkgs, ... }:
    {
      services.tranquil-pds = {
        enable = true;
        database.createLocally = true;

        settings = {
          server = {
            hostname = "pds";
            port = 8080;
          };

          secrets = {
            allow_insecure = true;
            jwt_secret = "test-jwt-secret-must-be-32-chars-long";
            dpop_secret = "test-dpop-secret-must-be-32-chars-long";
            master_key = "test-master-key-must-be-32-chars-long";
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("tranquil-pds.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://localhost:8080")
  '';

  meta.maintainers = with lib.maintainers; [ nelind ];
}
