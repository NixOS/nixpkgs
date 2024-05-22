{ lib, ... }:

{
  name = "fider-server";

  nodes = {
    machine = { pkgs, ... }: {
      services.fider = {
        enable = true;
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("fider.service")
    machine.wait_for_open_port(3000)
  '';

  meta.maintainers = [ lib.maintainers.drupol ];
}
