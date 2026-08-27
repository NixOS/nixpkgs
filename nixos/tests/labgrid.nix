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

      with subtest("Connect from client"):
          client.start()
          out = client.succeed("labgrid-client resources")

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

      with subtest("Check systemd hardening does not degrade unnoticed"):
          exact_threshold = 11
          out = coordinator.fail(f"systemd-analyze security labgrid-coordinator.service --threshold={exact_threshold-1}")
          out = coordinator.succeed(f"systemd-analyze security labgrid-coordinator.service --threshold={exact_threshold}")
    '';
}
