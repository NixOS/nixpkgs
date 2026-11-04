{ lib, ... }:
{
  name = "aurral";
  meta = with lib.maintainers; {
    maintainers = [ hougo ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.aurral = {
          enable = true;
          environment = {
            DOWNLOAD_FOLDER = "/var/lib/aurral-downloads";
          };
        };
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("aurral.service")
    machine.wait_for_open_port(3001)

    machine.succeed('curl --fail http://localhost:3001/api/health')

    with subtest("Restarts after a restore-style shutdown"):
        restarts = int(machine.succeed("systemctl show --property=NRestarts --value aurral.service"))
        machine.succeed("systemctl kill --kill-whom=main --signal=SIGTERM aurral.service")
        machine.wait_until_succeeds(
            f"test $(systemctl show --property=NRestarts --value aurral.service) -gt {restarts}"
        )
        machine.wait_for_unit("aurral.service")
        machine.wait_for_open_port(3001)
        machine.succeed('curl --fail http://localhost:3001/api/health')

    with subtest("An explicit stop keeps the service stopped"):
        machine.succeed("systemctl stop aurral.service")
        machine.sleep(2)
        machine.fail("systemctl is-active --quiet aurral.service")
  '';
}
