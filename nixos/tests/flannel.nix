import ./make-test.nix ({ pkgs, ...} : rec {
  name = "flannel";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = let
    flannelConfig = {
      services.flannel = {
        enable = true;
        network = "10.1.0.0/16";
        iface = "eth1";
        etcd.endpoints = ["http://etcd:2379"];
      };

      networking.firewall.allowedUDPPorts = [ 8472 ];
    };
  in {
    etcd = { ... }: {
      services = {
        etcd = {
          enable = true;
          listenClientUrls = ["http://0.0.0.0:2379"]; # requires ip-address for binding
          listenPeerUrls = ["http://0.0.0.0:2380"]; # requires ip-address for binding
          advertiseClientUrls = ["http://etcd:2379"];
          initialAdvertisePeerUrls = ["http://etcd:2379"];
          initialCluster = ["etcd=http://etcd:2379"];
        };
      };

      networking.firewall.allowedTCPPorts = [ 2379 ];
    };

    node1 = { ... }: {
      require = [flannelConfig];
    };

    node2 = { ... }: {
      require = [flannelConfig];
    };
  };

  testScript = ''
    startAll;

    $node1->waitForUnit("flannel.service");
    $node2->waitForUnit("flannel.service");

    my $ip1 = $node1->succeed("ip -4 addr show flannel.1 | grep -oP '(?<=inet).*(?=/)'");
    my $ip2 = $node2->succeed("ip -4 addr show flannel.1 | grep -oP '(?<=inet).*(?=/)'");

    $node1->waitUntilSucceeds("ping -c 1 $ip2");
    $node2->waitUntilSucceeds("ping -c 1 $ip1");
  '';
})
