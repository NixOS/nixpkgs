{ pkgs, lib, ... }:
{
  name = "uptimed";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine =
    { ... }:
    {
      services.uptimed.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("uptimed.service")
    machine.wait_for_file("/var/lib/uptimed/records")
    machine.succeed("uprecords")
  '';
}
