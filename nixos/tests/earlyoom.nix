{ lib, ... }:
{
  name = "earlyoom";
  meta.maintainers = with lib.maintainers; [
    ncfavier
    oxalica
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      # Limit VM resource usage.
      virtualisation.memorySize = 1024;

      services.earlyoom = {
        enable = true;
        # Use SIGKILL, or `tail` will catch SIGTERM and exit successfully.
        freeMemKillThreshold = 90;
      };

      systemd.services.testbloat = {
        description = "Create a lot of memory pressure";
        serviceConfig = {
          ExecStart = "${pkgs.coreutils}/bin/tail /dev/zero";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("earlyoom.service")

    with subtest("earlyoom should kill the bad service"):
        machine.fail("systemctl start --wait testbloat.service")
        assert machine.get_unit_info("testbloat.service")["Result"] == "signal"
        output = machine.succeed('journalctl -u earlyoom.service -b0')
        assert 'low memory! at or below SIGKILL limits' in output
  '';
}
