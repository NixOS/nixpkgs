import ./make-test.nix ({ pkgs, lib, ... }:
let
  # Change this to test a different version of Cassandra:
  testPackage = pkgs.cassandra;
  clusterName = "NixOS Automated-Test Cluster";

  testRemoteAuth = lib.versionAtLeast testPackage.version "3.11";
  jmxRoles = [{ username = "me"; password = "password"; }];
  jmxRolesFile = ./cassandra-jmx-roles;
  jmxAuthArgs = "-u ${(builtins.elemAt jmxRoles 0).username} -pw ${(builtins.elemAt jmxRoles 0).password}";

  # Would usually be assigned to 512M
  numMaxHeapSize = "400";
  getHeapLimitCommand = ''
    nodetool info | grep "^Heap Memory" | awk \'{print $NF}\'
  '';
  checkHeapLimitCommand = ''
    [ 1 -eq "$(echo "$(${getHeapLimitCommand}) < ${numMaxHeapSize}" | ${pkgs.bc}/bin/bc)" ]
  '';

  cassandraCfg = ipAddress:
    { enable = true;
      inherit clusterName;
      listenAddress = ipAddress;
      rpcAddress = ipAddress;
      seedAddresses = [ "192.168.1.1" ];
      package = testPackage;
      maxHeapSize = "${numMaxHeapSize}M";
      heapNewSize = "100M";
    };
  nodeCfg = ipAddress: extra: {pkgs, config, ...}:
    { environment.systemPackages = [ testPackage ];
      networking = {
        firewall.allowedTCPPorts = [ 7000 7199 9042 ];
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = ipAddress; prefixLength = 24; }
        ];
      };
      services.cassandra = cassandraCfg ipAddress // extra;
      virtualisation.memorySize = 1024;
    };
in
{
  name = "cassandra-ci";

  nodes = {
    cass0 = nodeCfg "192.168.1.1" {};
    cass1 = nodeCfg "192.168.1.2" (lib.optionalAttrs testRemoteAuth { inherit jmxRoles; remoteJmx = true; });
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
    subtest "Heap limit set correctly", sub {
      # Nodetool takes a while until it can display info
      $cass0->waitUntilSucceeds('nodetool info');
      $cass0->succeed('${checkHeapLimitCommand}');
    };

    # Check cluster interaction
    subtest "Bring up cluster", sub {
      $cass1->waitForUnit("cassandra.service");
      $cass1->waitUntilSucceeds("nodetool ${jmxAuthArgs} status | egrep -c '^UN' | grep 2");
      $cass0->succeed("nodetool status --resolve-ip | egrep '^UN[[:space:]]+cass1'");
    };
  '' + lib.optionalString testRemoteAuth ''
    subtest "Remote authenticated jmx", sub {
      # Doesn't work if not enabled
      $cass0->waitUntilSucceeds("nc -z localhost 7199");
      $cass1->fail("nc -z 192.168.1.1 7199");
      $cass1->fail("nodetool -h 192.168.1.1 status");

      # Works if enabled
      $cass1->waitUntilSucceeds("nc -z localhost 7199");
      $cass0->succeed("nodetool -h 192.168.1.2 ${jmxAuthArgs} status");
    };
  '' + ''
    subtest "Break and fix node", sub {
      $cass1->block;
      $cass0->waitUntilSucceeds("nodetool status --resolve-ip | egrep -c '^DN[[:space:]]+cass1'");
      $cass0->succeed("nodetool status | egrep -c '^UN'  | grep 1");
      $cass1->unblock;
      $cass1->waitUntilSucceeds("nodetool ${jmxAuthArgs} status | egrep -c '^UN'  | grep 2");
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
