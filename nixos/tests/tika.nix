{ lib, ... }:

{
  name = "tika-server";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.tika = {
          enable = true;
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("tika.service")
    machine.wait_for_open_port(9998)
  '';

  meta.maintainers = [ ];
}
