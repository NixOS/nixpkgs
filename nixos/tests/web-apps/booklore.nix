{ ... }:
{
  name = "booklore-nixos";

  nodes.machine =
    { pkgs, ... }:
    let
      passwordFile = pkgs.writeText "booklore_db_passwd" ''
        SECRET_PASSWORD
      '';
    in
    {
      services.booklore = {
        enable = true;
        secretFiles = {
          DATABASE_PASSWORD = toString passwordFile;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit('booklore.service')

    machine.wait_for_open_port(8081)
    machine.succeed('curl -s --fail -X POST -H "Content-Type: application/json" --data \'{"username":"admin","email":"admin@example.com","name":"Admin","password":"password"}\' http://localhost:8080/api/v1/setup')
  '';
}
