{ lib, pkgs, ... }:

let
  secretKeyFile = pkgs.writeText "secretKeyFile" ''
    V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12
  '';
in
{
  name = "unittcms";
  meta.maintainers = with lib.maintainers; [ RadxaYuntian ];

  nodes.machine =
    { config, ... }:
    {
      services = {
        unittcms = {
          enable = true;
          secretKeyFile = secretKeyFile;
        };

        nginx = {
          enable = true;
          virtualHosts."${config.services.unittcms.hostname}".locations = {
            "/".proxyPass =
              "http://${config.services.unittcms.hostname}:${toString config.services.unittcms.frontendPort}";
            "/api/".proxyPass = "http://127.0.0.1:${toString config.services.unittcms.backendPort}/";
          };
        };
      };

      systemd.services = {
        unittcms-backend.enableStrictShellChecks = true;
        unittcms-frontend.enableStrictShellChecks = true;
      };
    };

  testScript = ''
    # Ensure the service is started and reachable
    machine.wait_for_unit("unittcms-backend.service")
    machine.wait_for_open_port(8001)
    machine.succeed("curl --fail http://127.0.0.1:8001")
    machine.succeed("curl --fail http://127.0.0.1:8001/health")

    machine.wait_for_unit("unittcms-frontend.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl --fail http://127.0.0.1:8000")

    # Ensure the reverse proxy is configured correctly
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl --fail http://127.0.0.1")
    machine.succeed("curl --fail http://127.0.0.1/api")
    machine.succeed("curl --fail http://127.0.0.1/api/")
    machine.succeed("curl --fail http://127.0.0.1/api/health")
  '';
}
