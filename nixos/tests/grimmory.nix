{ pkgs, ... }:
{
  name = "grimmory";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ kraftnix ];
  };

  nodes = {
    grimmory =
      { config, pkgs, ... }:
      {
        services.grimmory = {
          enable = true;
          # extraArgs = [ "--debug" ];
          database.passwordFile = builtins.toFile "snakeoil-mysql-password" "deadbeef";
          webserver = "caddy";
          virtualHost = "localhost";
        };
      };
  };

  testScript = ''
    machine.wait_for_unit("mysql.service")
    machine.wait_for_unit("grimmory.service")
    machine.wait_for_open_port(6060)

    with subtest("Check Frontend accessible"):
      machine.succeed("curl --fail http://localhost/login")

    with subtest("Check API accessible"):
      machine.succeed("curl --fail http://localhost/api/v1/healthcheck")

    with subtest("Create an admin user"):
      machine.succeed('curl --fail -X POST -H "Content-Type: application/json" --data \'{"username":"admin","password":"snakeoil-password","name":"Admin","email":"admin@localhost"}\' http://localhost/api/v1/setup')
  '';
}
