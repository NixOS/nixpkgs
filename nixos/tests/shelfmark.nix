{ lib, ... }:
{
  name = "shelfmark";
  meta.maintainers = with lib.maintainers; [ jamiemagee ];

  nodes.machine = {
    services.shelfmark = {
      enable = true;
      environment.FLASK_HOST = "0.0.0.0";
    };
  };

  testScript = ''
    machine.wait_for_unit("shelfmark.service")
    machine.wait_for_open_port(8084)

    with subtest("Health endpoint responds"):
        machine.succeed("curl --fail http://localhost:8084/api/health")
  '';
}
