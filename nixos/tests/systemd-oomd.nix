import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "systemd-oomd";

    # This test is a simplified version of systemd's testsuite-55.
    # https://github.com/systemd/systemd/blob/v251/test/units/testsuite-55.sh
    nodes.machine =
      { pkgs, ... }:
      {
        # Limit VM resource usage.
        virtualisation.memorySize = 1024;
        systemd.oomd.extraConfig.DefaultMemoryPressureDurationSec = "1s";

        systemd.slices.workload = {
          description = "Test slice for memory pressure kills";
          sliceConfig = {
            MemoryAccounting = true;
            ManagedOOMMemoryPressure = "kill";
            ManagedOOMMemoryPressureLimit = "10%";
          };
        };

        systemd.services.testbloat = {
          description = "Create a lot of memory pressure";
          serviceConfig = {
            Slice = "workload.slice";
            MemoryHigh = "5M";
            ExecStart = "${pkgs.coreutils}/bin/tail /dev/zero";
          };
        };

        systemd.services.testchill = {
          description = "No memory pressure";
          serviceConfig = {
            Slice = "workload.slice";
            MemoryHigh = "3M";
            ExecStart = "${pkgs.coreutils}/bin/sleep infinity";
          };
        };
      };

    testScript = ''
      # Start the system.
      machine.wait_for_unit("multi-user.target")
      machine.succeed("oomctl")

      machine.succeed("systemctl start testchill.service")
      with subtest("OOMd should kill the bad service"):
          machine.fail("systemctl start --wait testbloat.service")
          assert machine.get_unit_info("testbloat.service")["Result"] == "oom-kill"

      with subtest("Service without memory pressure should be untouched"):
          machine.require_unit_state("testchill.service", "active")
    '';
  }
)
