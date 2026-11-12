{
  pkgs,
  lib,
  kernelPackages ? null,
  ...
}:
{
  name = "wg-access-server";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ xanderio ];
  };

  nodes = {
    server = {
      services.wg-access-server = {
        enable = true;
        settings = {
          adminUsername = "admin";
        };
        secretsFile = (
          pkgs.writers.writeYAML "secrets.yaml" {
            adminPassword = "hunter2";
          }
        );
      };
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("wg-access-server.service")
  '';
}
