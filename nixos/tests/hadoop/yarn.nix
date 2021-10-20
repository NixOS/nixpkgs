import ../make-test-python.nix ({...}: {
  nodes = {
    resourcemanager = {pkgs, ...}: {
      services.hadoop.package = pkgs.hadoop;
      services.hadoop.yarn.resourcemanager.enabled = true;
      services.hadoop.yarnSite = {
        "yarn.resourcemanager.scheduler.class" = "org.apache.hadoop.yarn.server.resourcemanager.scheduler.fifo.FifoScheduler";
      };
      networking.firewall.allowedTCPPorts = [
        8088 # resourcemanager.webapp.address
        8031 # resourcemanager.resource-tracker.address
      ];
    };
    nodemanager = {pkgs, ...}: {
      services.hadoop.package = pkgs.hadoop;
      services.hadoop.yarn.nodemanager.enabled = true;
      services.hadoop.yarnSite = {
        "yarn.resourcemanager.hostname" = "resourcemanager";
        "yarn.nodemanager.log-dirs" = "/tmp/userlogs";
        "yarn.nodemanager.address" = "0.0.0.0:8041";
      };
      networking.firewall.allowedTCPPorts = [
        8042 # nodemanager.webapp.address
        8041 # nodemanager.address
      ];
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
    nodemanager.wait_for_open_port(8041)

    resourcemanager.succeed("curl -f http://localhost:8088")
    nodemanager.succeed("curl -f http://localhost:8042")
  '';
})
