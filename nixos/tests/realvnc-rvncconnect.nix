{ lib, pkgs, ... }:

{
  name = "realvnc-rvncconnect";
  meta.maintainers = pkgs.realvnc-rvncconnect.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      programs.realvnc-rvncconnect = {
        enable = true;
        openFirewall = true;
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("rvncserver-x11-serviced.service")
    machine.succeed("systemctl status rvncserver-x11-serviced.service")
    machine.succeed("rvncconnect -help")
  '';
}
