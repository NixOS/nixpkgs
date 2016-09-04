import ./make-test.nix ({ pkgs, ...}:
let
  user = "cassandra";
  nodeCfg = nodes: selfIP: cassandraOpts:
    {
      services.cassandra = {
        enable = true;
        listenAddress = selfIP;
        rpcAddress = "0.0.0.0";
        seeds = [ "192.168.1.1" ];
        package = pkgs.cassandra_2_0;
        jre = pkgs.openjdk;
        clusterName = "ci ahoy";
        authenticator = "PasswordAuthenticator";
        authorizer = "CassandraAuthorizer";
        user = user;
      } // cassandraOpts;
      nixpkgs.config.allowUnfree = true;
      virtualisation.memorySize = 1024;
    };

in
{
  name = "cassandra-ci";

  nodes = {
    cass0 = {pkgs, config, nodes, ...}: nodeCfg nodes "192.168.1.1" {};
    cass1 = {pkgs, config, nodes, ...}: nodeCfg nodes "192.168.1.2" {};
    cass2 = {pkgs, config, nodes, ...}: nodeCfg nodes "192.168.1.3" {
      extraParams = [
        ''JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address=192.168.1.2"''
      ];
      listenAddress = "192.168.1.3";
    };
  };

  testScript = ''
    subtest "start seed", sub {
      $cass0->waitForUnit("cassandra.service");
      $cass0->waitForOpenPort(9160);
      $cass0->execute("echo show version | cqlsh localhost -u cassandra -p cassandra");
      sleep 2;
      $cass0->succeed("echo show version | cqlsh localhost -u cassandra -p cassandra");
      $cass1->start;
    };
    subtest "cassandra user/group", sub {
      $cass0->succeed("id \"${user}\" >/dev/null");
      $cass1->succeed("id \"${user}\" >/dev/null");
    };
    subtest "bring up cassandra cluster", sub {
      $cass1->waitForUnit("cassandra.service");
      $cass0->waitUntilSucceeds("nodetool status | grep -c UN  | grep 2");
    };
    subtest "break and fix node", sub {
      $cass0->block;
      $cass0->waitUntilSucceeds("nodetool status | grep -c DN  | grep 1");
      $cass0->unblock;
      $cass0->waitUntilSucceeds("nodetool status | grep -c UN  | grep 2");
    };
    subtest "replace crashed node", sub {
      $cass1->crash;
      $cass2->start;
      $cass2->waitForUnit("cassandra.service");
      $cass0->waitUntilFails("nodetool status | grep UN  | grep 192.168.1.2");
      $cass0->waitUntilSucceeds("nodetool status | grep UN | grep 192.168.1.3");
    };
  '';
})
