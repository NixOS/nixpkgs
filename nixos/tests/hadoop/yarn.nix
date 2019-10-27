import ../make-test.nix ({...}: {
  nodes = {
    resourcemanager = {pkgs, ...}: {
      services.hadoop.package = pkgs.hadoop_3_1;
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
      services.hadoop.package = pkgs.hadoop_3_1;
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
    startAll;

    $resourcemanager->waitForUnit("yarn-resourcemanager");
    $resourcemanager->waitForUnit("network.target");
    $resourcemanager->waitForOpenPort(8031);
    $resourcemanager->waitForOpenPort(8088);

    $nodemanager->waitForUnit("yarn-nodemanager");
    $nodemanager->waitForUnit("network.target");
    $nodemanager->waitForOpenPort(8042);
    $nodemanager->waitForOpenPort(8041);

    $resourcemanager->succeed("curl http://localhost:8088");
    $nodemanager->succeed("curl http://localhost:8042");
  '';
})
