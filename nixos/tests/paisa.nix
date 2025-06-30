{ ... }:
{
  name = "paisa";
  nodes.machine =
    { pkgs, ... }:
    {
      systemd.services.paisa = {
        description = "Paisa";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${pkgs.paisa}/bin/paisa serve";
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
