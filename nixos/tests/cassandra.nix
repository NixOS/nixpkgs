import ./make-test.nix ({ pkgs, ...}:
let
  # Change this to test a different version of Cassandra:
  testPackage = pkgs.cassandra;
  cassandraCfg = 
    { enable = true;
      listenAddress = null;
      listenInterface = "eth1";
      rpcAddress = null;
      rpcInterface = "eth1";
      extraConfig =
        { start_native_transport = true;
          seed_provider =
            [{ class_name = "org.apache.cassandra.locator.SimpleSeedProvider";
               parameters = [ { seeds = "cass0"; } ];
            }];
        };
      package = testPackage;
    };
  nodeCfg = extra: {pkgs, config, ...}:
    { environment.systemPackages = [ testPackage ];
      networking.firewall.enable = false;
      services.cassandra = cassandraCfg // extra;
      virtualisation.memorySize = 1024;
    };
in
{
  name = "cassandra-ci";

  nodes = {
    cass0 = nodeCfg {};
    cass1 = nodeCfg {};
    cass2 = nodeCfg { jvmOpts = [ "-Dcassandra.replace_address=cass1" ]; };
  };

  testScript = ''
    subtest "timers exist", sub {
      $cass0->succeed("systemctl list-timers | grep cassandra-full-repair.timer");
      $cass0->succeed("systemctl list-timers | grep cassandra-incremental-repair.timer");
    };
    subtest "can connect via cqlsh", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nc -z cass0 9042");
      $cass0->succeed("echo 'show version;' | cqlsh cass0");
    };
    subtest "nodetool is operational", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nc -z localhost 7199");
      $cass0->succeed("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass0'");
    };
    subtest "bring up cluster", sub {
      $cass1->waitForUnit("cassandra.service");
      $cass1->waitUntilSucceeds("nodetool status | egrep -c '^UN' | grep 2");
      $cass0->succeed("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass1'");
    };
    subtest "break and fix node", sub {
      $cass1->block;
      $cass0->waitUntilSucceeds("nodetool status --resolve-ip | egrep -c '^DN[[:space:]]+cass1'");
      $cass0->succeed("nodetool status | egrep -c '^UN'  | grep 1");
      $cass1->unblock;
      $cass1->waitUntilSucceeds("nodetool status | egrep -c '^UN'  | grep 2");
      $cass0->succeed("nodetool status | egrep -c '^UN'  | grep 2");
    };
    subtest "replace crashed node", sub {
      $cass1->crash;
      $cass2->waitForUnit("cassandra.service");
      $cass0->waitUntilFails("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass1'");
      $cass0->waitUntilSucceeds("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass2'");
    };
  '';
})
