{ lib, ... }:
let
  mainPort = "8080";
in
{
  name = "litellm";

  nodes = {
    machine =
      { ... }:
      {
        services.litellm = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("litellm.service")
    machine.wait_for_open_port(${mainPort})
  '';

  meta = {
    maintainers = [ ];
  };
}
