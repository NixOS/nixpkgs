{
  lib,
  config,
  ...
}:
let
  keys = import ./wireguard/snakeoil-keys.nix;
in
{
  name = "wg-access-server";
  meta = with lib.maintainers; {
    maintainers = [ xanderio ];
  };

  nodes = {
    server = { pkgs, ... }: {
      services.wg-access-server = {
        enable = true;
        settings = {
          adminUsername = "admin";
          enableMetadata = true;
        };
        secretsFile = (
          pkgs.writers.writeYAML "secrets.yaml" {
            adminPassword = "hunter2";
            wireguard.privateKey = keys.peer0.privateKey;
          }
        );
      };
    };
  };

  testScript =
    # python
    ''
      start_all()

      server.wait_for_unit("wg-access-server.service")
      server.wait_for_open_port(8000)
      assert "${config.nodes.server.services.wg-access-server.package.version}" in server.succeed("curl -L http://localhost:8000/metrics | grep wg_access_server_build_info")
    '';
}
