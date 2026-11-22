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
            LIBRARY_FOLDER = "/var/lib/aurral-music";
          };
        };
      };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("aurral.service")
    machine.wait_for_open_port(3001)

    machine.succeed('curl --fail http://localhost:3001/api/health')
  '';
}
