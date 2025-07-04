{ ... }:
{
  name = "paisa";
  nodes.machine =
    { pkgs, lib, ... }:
    {
      systemd.services.paisa = {
        description = "Paisa";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${lib.getExe pkgs.paisa} serve";
      };
    };
  testScript = ''
    start_all()

    machine.systemctl("start network-online.target")
    machine.wait_for_unit("network-online.target")
    machine.wait_for_unit("paisa.service")
    machine.wait_for_open_port(7500)

    machine.succeed("curl --location --fail http://localhost:7500")
  '';
}
