{ lib, ... }:
{
  name = "reposilite";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services = {
          mysql = {
            enable = true;
            package = pkgs.mariadb;
            ensureDatabases = [ "reposilite" ];
            initialScript = pkgs.writeText "reposilite-test-db-init" ''
              CREATE USER 'reposilite'@'localhost' IDENTIFIED BY 'ReposiliteDBPass';
              GRANT ALL PRIVILEGES ON reposilite.* TO 'reposilite'@'localhost';
              FLUSH PRIVILEGES;
            '';
          };

          reposilite = {
            enable = true;
            plugins = with pkgs.reposilitePlugins; [
              checksum
              groovy
            ];
            extraArgs = [
              "--token"
              "test:SuperSecretTestToken"
            ];
            database = {
              type = "mariadb";
              passwordFile = "/run/reposiliteDbPass";
            };
            settings.port = 8080;
          };
        };
      };
  };

  testScript = ''
    machine.start()

    machine.execute("echo \"ReposiliteDBPass\" > /run/reposiliteDbPass && chmod 600 /run/reposiliteDbPass && chown reposilite:reposilite /run/reposiliteDbPass")
    machine.wait_for_unit("reposilite.service")
    machine.wait_for_open_port(8080)

    machine.fail("curl -Sf localhost:8080/api/auth/me")
    machine.succeed("curl -Sfu test:SuperSecretTestToken localhost:8080/api/auth/me")
  '';

  meta.maintainers = [ lib.maintainers.uku3lig ];
}
