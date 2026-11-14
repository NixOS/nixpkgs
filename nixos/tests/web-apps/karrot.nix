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
    machine.wait_for_unit("redis-karrot.service")
    machine.wait_for_unit("karrot.service")
    machine.wait_for_unit("karrot-worker.service", timeout=60)
    machine.wait_for_open_port(8000, timeout=60)

    with subtest("Healthcheck endpoint"):
        health = machine.succeed("curl -sSf http://127.0.0.1:8000/api/healthcheck/ | jq .")
        print("Healthcheck response:", health)
        machine.succeed("curl -sSf http://127.0.0.1:8000/api/healthcheck/ | jq -e '.status == \"ok\"'")

    with subtest("Frontend serves HTML"):
        machine.succeed("curl -sSf http://127.0.0.1:8000/ | grep -i '<!DOCTYPE html>'")

    with subtest("Public bootstrap API"):
        bootstrap = machine.succeed("curl -sSf http://127.0.0.1:8000/api/bootstrap/ | jq .")
        print("Bootstrap response:", bootstrap)

    with subtest("Karrot CLI manage tool"):
        machine.succeed("karrot-manage check")
  '';

  meta.teams = with lib.teams; [ ngi ];
}
