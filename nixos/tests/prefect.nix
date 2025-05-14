{ lib, ... }:
let
  mainPort = "4200";
in
{
  name = "prefect";

  nodes = {
    machine =
      { ... }:
      {
        services.prefect = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("prefect-server.service")
    machine.wait_for_open_port("${mainPort}")
  '';

  meta = with lib.maintainers; {
    maintainers = [ happysalada ];
  };
}
