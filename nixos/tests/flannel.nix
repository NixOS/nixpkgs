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
    etcd = { config, pkgs, ... }: {
      services = {
        etcd = {
          enable = true;
          listenClientUrls = ["http://etcd:2379"];
          listenPeerUrls = ["http://etcd:2380"];
          initialAdvertisePeerUrls = ["http://etcd:2379"];
          initialCluster = ["etcd=http://etcd:2379"];
        };
      };

      networking.firewall.allowedTCPPorts = [ 2379 ];
    };

    node1 = { config, ... }: {
      require = [flannelConfig];
    };

    node2 = { config, ... }: {
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
