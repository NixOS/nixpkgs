{ pkgs, ... }:
{
  name = "lact";
  meta = {
    inherit (pkgs.lact.meta) maintainers;
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.lact.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("lactd.service")
    machine.wait_for_file("/run/lactd.sock")
  '';
}
