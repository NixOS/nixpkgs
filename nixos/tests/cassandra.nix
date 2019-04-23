import ./make-test.nix ({ pkgs, ...}:
let
  # Change this to test a different version of Cassandra:
  testPackage = pkgs.cassandra;
  clusterName = "NixOS Automated-Test Cluster";

  cassandraCfg = ipAddress:
    { enable = true;
      inherit clusterName;
      listenAddress = ipAddress;
      rpcAddress = ipAddress;
      seedAddresses = [ "192.168.1.1" ];
      package = testPackage;
    };
  nodeCfg = ipAddress: extra: {pkgs, config, ...}:
    { environment.systemPackages = [ testPackage ];
      networking.firewall.enable = false;
      services.cassandra = cassandraCfg ipAddress // extra;
      virtualisation.memorySize = 1024;
    };
in
{
  name = "cassandra-ci";

  nodes = {
    cass0 = nodeCfg "192.168.1.1" {};
    cass1 = nodeCfg "192.168.1.2" {};
    cass2 = nodeCfg "192.168.1.3" { jvmOpts = [ "-Dcassandra.replace_address=cass1" ]; };
  };

  testScript = ''
    # Check configuration
    subtest "Timers exist", sub {
      $cass0->succeed("systemctl list-timers | grep cassandra-full-repair.timer");
      $cass0->succeed("systemctl list-timers | grep cassandra-incremental-repair.timer");
    };
    subtest "Can connect via cqlsh", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nc -z cass0 9042");
      $cass0->succeed("echo 'show version;' | cqlsh cass0");
    };
    subtest "Nodetool is operational", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nc -z localhost 7199");
      $cass0->succeed("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass0'");
    };
    subtest "Cluster name was set", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nc -z localhost 7199");
      $cass0->waitUntilSucceeds("nodetool describecluster | grep 'Name: ${clusterName}'");
    };

    # Check cluster interaction
    subtest "Bring up cluster", sub {
      $cass1->waitForUnit("cassandra.service");
      $cass1->waitUntilSucceeds("nodetool status | egrep -c '^UN' | grep 2");
      $cass0->succeed("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass1'");
    };
    subtest "Break and fix node", sub {
      $cass1->block;
      $cass0->waitUntilSucceeds("nodetool status --resolve-ip | egrep -c '^DN[[:space:]]+cass1'");
      $cass0->succeed("nodetool status | egrep -c '^UN'  | grep 1");
      $cass1->unblock;
      $cass1->waitUntilSucceeds("nodetool status | egrep -c '^UN'  | grep 2");
      $cass0->succeed("nodetool status | egrep -c '^UN'  | grep 2");
    };
    subtest "Replace crashed node", sub {
      $cass1->crash;
      $cass2->waitForUnit("cassandra.service");
      $cass0->waitUntilFails("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass1'");
      $cass0->waitUntilSucceeds("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass2'");
    };
  '';
})
