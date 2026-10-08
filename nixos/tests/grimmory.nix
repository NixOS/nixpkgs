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
          database.passwordFile = builtins.toFile "snakeoil-mysql-password" "deadbeef";
        };
        specialisation.caddy = {
          inheritParentConfig = true;
          configuration = {
            systemd.tmpfiles.rules = [
              "d /bookdrop 0740 grimmory grimmory -"
              "d /books 0740 grimmory grimmory -"
            ];
            services.grimmory = {
              domain = "localhost";
              caddy.enable = true;
              caddy.virtualHost.extraConfig = "tls internal";
              bookdropDir = "/bookdrop";
              booksDir = "/books";
              database.passwordFile = pkgs.lib.mkForce null;
              environment.DATABASE_PASSWORD = "deadbeef1";
            };
          };
        };
        specialisation.nginx = {
          inheritParentConfig = true;
          configuration = {
            services.grimmory = {
              domain = "localhost";
              port = 8888;
              nginx.enable = true;
              database.passwordFile = pkgs.lib.mkForce null;
              environmentFile = builtins.toFile "snakeoil-mysql-password" "DATABASE_PASSWORD=deadbeef2";
            };
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
    with subtest("Testing basic Grimmory config"):
      grimmory.wait_for_unit("mysql.service")
      grimmory.wait_for_unit("grimmory.service")
      grimmory.wait_for_open_port(6060)

      with subtest("Check Frontend accessible"):
        grimmory.succeed("curl --fail http://localhost:6060/login")

      with subtest("Check API accessible"):
        grimmory.succeed("curl --fail http://localhost:6060/api/v1/healthcheck")

      with subtest("Create an admin user"):
        grimmory.succeed('curl --fail -X POST -H "Content-Type: application/json" --data \'{"username":"admin","password":"snakeoil-password","name":"Admin","email":"admin@localhost"}\' http://localhost:6060/api/v1/setup')

    with subtest("Testing nginx Grimmory config"):
      grimmory.succeed("${nodes.grimmory.system.build.toplevel}/specialisation/nginx/bin/switch-to-configuration test")
      grimmory.wait_for_unit("nginx.service")
      grimmory.wait_for_unit("mysql.service")
      grimmory.wait_for_unit("grimmory.service")
      grimmory.wait_for_open_port(8888)

      with subtest("Check Frontend accessible via nginx"):
        grimmory.succeed("curl --fail http://localhost/login")

      with subtest("Check API accessible via nginx"):
        grimmory.succeed("curl --fail http://localhost/api/v1/healthcheck")

    with subtest("Testing caddy Grimmory config"):
      grimmory.succeed("${nodes.grimmory.system.build.toplevel}/specialisation/caddy/bin/switch-to-configuration test")
      grimmory.wait_for_unit("caddy.service")
      grimmory.wait_for_unit("mysql.service")
      grimmory.wait_for_unit("grimmory.service")
      grimmory.wait_for_open_port(6060)

      with subtest("Check Frontend accessible via caddy"):
        grimmory.succeed("curl --fail -k https://localhost/login")

      with subtest("Check API accessible via caddy"):
        grimmory.succeed("curl --fail -k https://localhost/api/v1/healthcheck")
  '';
}
