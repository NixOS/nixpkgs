# This only tests if YARN is able to start its services
import ../make-test-python.nix (
  { package, ... }:
  {
    name = "hadoop-yarn";

    nodes = {
      resourcemanager =
        { ... }:
        {
          services.hadoop = {
            inherit package;
            yarn.resourcemanager = {
              enable = true;
              openFirewall = true;
            };
          };
        };
      nodemanager =
        { options, lib, ... }:
        {
          services.hadoop = {
            inherit package;
            yarn.nodemanager = {
              enable = true;
              openFirewall = true;
            };
            yarnSite = {
              "yarn.resourcemanager.hostname" = "resourcemanager";
              "yarn.nodemanager.log-dirs" = "/tmp/userlogs";
            };
          };
        };
    };

    testScript = ''
      start_all()

      resourcemanager.wait_for_unit("yarn-resourcemanager")
      resourcemanager.wait_for_unit("network.target")
      resourcemanager.wait_for_open_port(8031)
      resourcemanager.wait_for_open_port(8088)

      nodemanager.wait_for_unit("yarn-nodemanager")
      nodemanager.wait_for_unit("network.target")
      nodemanager.wait_for_open_port(8042)

      resourcemanager.succeed("curl -f http://localhost:8088")
      nodemanager.succeed("curl -f http://localhost:8042")
    '';
  }
)
