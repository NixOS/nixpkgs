{ lib, pkgs, ... }:

{
  name = "sema";
  meta.maintainers = with lib.maintainers; [ crimeminister ];

  nodes.machine = {
    programs.sema.enable = true;
    services.sema-notebook.enable = true;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("sema --version | grep -q '${pkgs.sema.version}'")
    machine.wait_for_unit("sema-notebook.service")
    machine.wait_for_open_port(8888)
  '';
}
