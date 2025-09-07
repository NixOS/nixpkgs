{ pkgs, lib, ... }:
{
  name = "irqbalance";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine =
    { config, ... }:
    {
      virtualisation.cores = 2;
      services.irqbalance.enable = true;

      systemd.services.irqbalance.serviceConfig.ExecStart = [
        ""
        "${lib.getExe config.services.irqbalance.package} --journal --debug"
      ];
    };

  testScript = ''
    machine.wait_for_unit("irqbalance.service")
    machine.wait_until_succeeds("journalctl -u irqbalance.service --grep='Package 0'")
  '';
}
