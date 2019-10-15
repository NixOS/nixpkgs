import ./make-test.nix ({ pkgs, lib, ... }:
let
  # Change this to test a different version of Cassandra:
  testPackage = pkgs.cassandra;
  clusterName = "NixOS Automated-Test Cluster";

  testRemoteAuth = lib.versionAtLeast testPackage.version "3.11";
  jmxRoles = [{ username = "me"; password = "password"; }];
  jmxRolesFile = ./cassandra-jmx-roles;
  jmxAuthArgs = "-u ${(builtins.elemAt jmxRoles 0).username} -pw ${(builtins.elemAt jmxRoles 0).password}";
  jmxPort = 7200;  # Non-standard port so it doesn't accidentally work

  # Would usually be assigned to 512M
  numMaxHeapSize = "400";
  getHeapLimitCommand = ''
    nodetool info -p ${toString jmxPort} | grep "^Heap Memory" | awk \'{print $NF}\'
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
      inherit jmxPort;
    };
  nodeCfg = ipAddress: extra: {pkgs, config, ...}: rec {
    environment.systemPackages = [ testPackage ];
    networking = {
      firewall.allowedTCPPorts = [ 7000 9042 services.cassandra.jmxPort ];
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

  testScript = let
    jmxPortS = toString jmxPort;
  in ''
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
      $cass0->waitUntilSucceeds("nc -z localhost ${jmxPortS}");
      $cass0->succeed("nodetool status -p ${jmxPortS} --resolve-ip | egrep '^UN[[:space:]]+cass0'");
    };
    subtest "Cluster name was set", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nc -z localhost ${jmxPortS}");
      $cass0->waitUntilSucceeds("nodetool describecluster -p ${jmxPortS} | grep 'Name: ${clusterName}'");
    };
    subtest "Heap limit set correctly", sub {
      # Nodetool takes a while until it can display info
      $cass0->waitUntilSucceeds('nodetool info -p ${jmxPortS}');
      $cass0->succeed('${checkHeapLimitCommand}');
    };

    # Check cluster interaction
    subtest "Bring up cluster", sub {
      $cass1->waitForUnit("cassandra.service");
      $cass1->waitUntilSucceeds("nodetool -p ${jmxPortS} ${jmxAuthArgs} status | egrep -c '^UN' | grep 2");
      $cass0->succeed("nodetool status -p ${jmxPortS} --resolve-ip | egrep '^UN[[:space:]]+cass1'");
    };
  '' + lib.optionalString testRemoteAuth ''
    subtest "Remote authenticated jmx", sub {
      # Doesn't work if not enabled
      $cass0->waitUntilSucceeds("nc -z localhost ${jmxPortS}");
      $cass1->fail("nc -z 192.168.1.1 ${toString jmxPort}");
      $cass1->fail("nodetool -p ${jmxPortS} -h 192.168.1.1 status");

      # Works if enabled
      $cass1->waitUntilSucceeds("nc -z localhost ${toString jmxPort}");
      $cass0->succeed("nodetool -p ${jmxPortS} -h 192.168.1.2 ${jmxAuthArgs} status");
    };
  '' + ''
    subtest "Break and fix node", sub {
      $cass1->block;
      $cass0->waitUntilSucceeds("nodetool status -p ${jmxPortS} --resolve-ip | egrep -c '^DN[[:space:]]+cass1'");
      $cass0->succeed("nodetool status -p ${jmxPortS} | egrep -c '^UN'  | grep 1");
      $cass1->unblock;
      $cass1->waitUntilSucceeds("nodetool -p ${jmxPortS} ${jmxAuthArgs} status | egrep -c '^UN'  | grep 2");
      $cass0->succeed("nodetool status -p ${jmxPortS} | egrep -c '^UN'  | grep 2");
    };
    subtest "Replace crashed node", sub {
      $cass1->crash;
      $cass2->waitForUnit("cassandra.service");
      $cass0->waitUntilFails("nodetool status -p ${jmxPortS} --resolve-ip | egrep '^UN[[:space:]]+cass1'");
      $cass0->waitUntilSucceeds("nodetool status -p ${jmxPortS} --resolve-ip | egrep '^UN[[:space:]]+cass2'");
    };
  '';
})
