{ lib, ... }:

let
  opengistPort = 16517;
in
{
  name = "opengist";
  meta = with lib.maintainers; {
    maintainers = [ newam ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.opengist = {
          enable = true;
          settings = {
            "http.port" = opengistPort;
          };
        };
      };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("opengist.service")
    machine.wait_for_open_port(${toString opengistPort})

    machine.succeed("curl --fail http://127.0.0.1:${toString opengistPort}")
  '';
}
