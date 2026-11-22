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

    unmanaged_irq_count = machine.succeed("journalctl -u irqbalance.service -o cat --grep 'affinity is now unmanaged' | sort -u | wc -l")

    # The number of unmanaged IRQs is not entirely stable, but there is likely something
    # wrong if any more that 2 queues are unmanaged
    assert int(unmanaged_irq_count) <= 2
  '';
}
