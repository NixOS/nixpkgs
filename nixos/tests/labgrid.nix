{ pkgs, ... }:
{
  name = "Labgrid";
  meta.maintainers = with pkgs.lib.maintainers; [
    aiyion
    emantor
  ];

  nodes.coordinator =
    { pkgs, ... }:
    {
      services.labgrid.coordinator.enable = true;
      services.labgrid.coordinator.openFirewall = true;
    };

  nodes.client =
    { pkgs, ... }:
    {
      environment.variables = {
        LG_COORDINATOR = "coordinator:20408";
      };
      environment.systemPackages = [ pkgs.python3Packages.labgrid ];
    };

  nodes.exporter =
    { pkgs, ... }:
    {
      services.labgrid.exporter.enable = true;
      services.labgrid.exporter.coordinatorAddress = "coordinator";
      services.labgrid.exporter.name = "testexportername";
      services.labgrid.exporter.resources = {
        testgroup = {
          location = "testlocation";
          NetworkInterface = {
            ifname = "lo";
          };
        };
      };
    };

  testScript =
    { nodes, ... }:
    #python
    ''
      def assert_contains(haystack, needle):
          if needle not in haystack:
              print("The haystack that will cause the following exception is:")
              print("---")
              print(haystack)
              print("---")
              raise Exception(f"Expected string '{needle}' was not found")

      with subtest("Wait for coordinator startup"):
          coordinator.start()
          coordinator.wait_for_unit("labgrid-coordinator.service")
          coordinator.wait_for_open_port(20408)

      with subtest("Wait for exporter startup"):
          exporter.start()
          exporter.wait_for_unit("labgrid-exporter.service")

      with subtest("Connect from client"):
          client.start()
          out = client.succeed("labgrid-client resources")
          assert_contains(out, "testexportername/testgroup/RemoteNetworkInterface")

      with subtest("Create place"):
          client.succeed("labgrid-client -p testplace create")
          out = client.succeed("labgrid-client places")
          assert_contains(out, "testplace")
          # Give the coordinator enough time to persist place creation
          coordinator.wait_until_succeeds("grep -q testplace /var/lib/labgrid-coordinator/places.yaml")

      with subtest("Test coordinator persistence"):
          coordinator.shutdown()
          coordinator.start()
          coordinator.wait_for_unit("labgrid-coordinator.service")
          coordinator.wait_for_open_port(20408)
          out = client.succeed("labgrid-client places")
          assert_contains(out, "testplace")

      with subtest("Check systemd hardening does not degrade unnoticed (coordinator)"):
          exact_threshold = 11
          out = coordinator.fail(f"systemd-analyze security labgrid-coordinator.service --threshold={exact_threshold-1}")
          out = coordinator.succeed(f"systemd-analyze security labgrid-coordinator.service --threshold={exact_threshold}")

      with subtest("Check systemd hardening does not degrade unnoticed (exporter)"):
          exact_threshold = 11
          out = exporter.fail(f"systemd-analyze security labgrid-exporter.service --threshold={exact_threshold-1}")
          out = exporter.succeed(f"systemd-analyze security labgrid-exporter.service --threshold={exact_threshold}")
    '';
}
