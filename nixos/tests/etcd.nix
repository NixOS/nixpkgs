# This test runs etcd as single node, multy node and using discovery

import ./make-test.nix ({ pkgs, ... } : {
  name = "etcd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    simple =
      { config, pkgs, nodes, ... }:
        {
          services.etcd.enable = true;
          services.etcd.listenClientUrls = ["http://0.0.0.0:4001"];
          environment.systemPackages = [ pkgs.curl ];
          networking.firewall.allowedTCPPorts = [ 4001 ];
        };


    node1 =
      { config, pkgs, nodes, ... }:
        {
          services = {
            etcd = {
              enable = true;
              listenPeerUrls = ["http://0.0.0.0:7001"];
              initialAdvertisePeerUrls = ["http://node1:7001"];
              initialCluster = ["node1=http://node1:7001" "node2=http://node2:7001"];
            };
          };

          networking.firewall.allowedTCPPorts = [ 7001 ];
        };

    node2 =
      { config, pkgs, ... }:
        {
          services = {
            etcd = {
              enable = true;
              listenPeerUrls = ["http://0.0.0.0:7001"];
              initialAdvertisePeerUrls = ["http://node2:7001"];
              initialCluster = ["node1=http://node1:7001" "node2=http://node2:7001"];
            };
          };

          networking.firewall.allowedTCPPorts = [ 7001 ];
        };

    discovery1 =
      { config, pkgs, nodes, ... }:
        {
          services = {
            etcd = {
              enable = true;
              listenPeerUrls = ["http://0.0.0.0:7001"];
              initialAdvertisePeerUrls = ["http://discovery1:7001"];
              discovery = "http://simple:4001/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83/";
            };
          };

          networking.firewall.allowedTCPPorts = [ 7001 ];
        };

    discovery2 =
      { config, pkgs, ... }:
        {
          services = {
            etcd = {
              enable = true;
              listenPeerUrls = ["http://0.0.0.0:7001"];
              initialAdvertisePeerUrls = ["http://discovery2:7001"];
              discovery = "http://simple:4001/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83/";
            };
          };

          networking.firewall.allowedTCPPorts = [ 7001 ];
        };
    };

  testScript = ''
    subtest "single node", sub {
      $simple->start();
      $simple->waitForUnit("etcd.service");
      $simple->waitUntilSucceeds("etcdctl set /foo/bar 'Hello world'");
      $simple->waitUntilSucceeds("etcdctl get /foo/bar | grep 'Hello world'");
    };

    subtest "multy node", sub {
      $node1->start();
      $node2->start();
      $node1->waitForUnit("etcd.service");
      $node2->waitForUnit("etcd.service");
      $node1->waitUntilSucceeds("etcdctl set /foo/bar 'Hello world'");
      $node2->waitUntilSucceeds("etcdctl get /foo/bar | grep 'Hello world'");
      $node1->shutdown();
      $node2->shutdown();
    };

    subtest "discovery", sub {
      $simple->succeed("curl -X PUT http://localhost:4001/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817f0fb83/_config/size -d value=2");

      $discovery1->start();
      $discovery2->start();
      $discovery1->waitForUnit("etcd.service");
      $discovery2->waitForUnit("etcd.service");
      $discovery1->waitUntilSucceeds("etcdctl set /foo/bar 'Hello world'");
      $discovery2->waitUntilSucceeds("etcdctl get /foo/bar | grep 'Hello world'");
    };
  '';
})
