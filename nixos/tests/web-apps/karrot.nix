{
  lib,
  pkgs,
  ...
}:
{
  name = "karrot";
  nodes.machine =
    { ... }:
    {
      services.karrot = {
        enable = true;
        nginx.enable = true;
        settings = {
          allowedHosts = [
            "localhost"
            "127.0.0.1"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        curl
        jq
      ];
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("postgresql.target")
    machine.wait_for_unit("karrot.target", timeout=60)
    machine.wait_for_unit("nginx.service", timeout=60)
    machine.wait_for_open_port(8000, timeout=60)
    machine.wait_for_open_port(80, timeout=60)

    with subtest("Healthcheck endpoint directly on backend"):
        health = machine.succeed("curl -sSf http://127.0.0.1:8000/api/healthcheck/ | jq .")
        print("Healthcheck response:", health)
        machine.succeed("curl -sSf http://127.0.0.1:8000/api/healthcheck/ | jq -e '.status == \"ok\"'")

    with subtest("Nginx serves frontend HTML directly"):
        machine.succeed("curl -sSf http://127.0.0.1/ | grep -i '<!DOCTYPE html>'")

    with subtest("Nginx proxies API endpoints"):
        machine.succeed("curl -sSf http://127.0.0.1/api/healthcheck/ | jq -e '.status == \"ok\"'")
        bootstrap = machine.succeed("curl -sSf http://127.0.0.1/api/bootstrap/ | jq .")
        print("Bootstrap response:", bootstrap)

    with subtest("Karrot CLI manage tool"):
        machine.succeed("karrot-manage check")
  '';

  # Debug interactively with:
  # - nix run .#nixosTests.karrot.driverInteractive -L
  # - start_all() / run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes.machine =
    { config, ... }:
    let
      inherit (config.services.karrot.settings.listen) port;
    in
    {
      # not needed, only for manual interactive debugging
      virtualisation.memorySize = 4096;
      environment.systemPackages = with pkgs; [
        htop
      ];

      virtualisation.forwardPorts =
        map
          (p: {
            from = "host";
            host.port = p;
            guest.port = p;
          })
          [
            port
          ]
        ++ lib.optionals config.services.karrot.nginx.enable [
          {
            from = "host";
            host.port = 8080;
            guest.port = 80;
          }
        ];

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [
        port
      ] ++ lib.optional config.services.karrot.nginx.enable 80;
    };

  meta.teams = with lib.teams; [ ngi ];
}
