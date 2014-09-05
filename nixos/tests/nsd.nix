let
  common = { pkgs, ... }: {
    networking.firewall.enable = false;
    networking.useDHCP = false;
    # for a host utility with IPv6 support
    environment.systemPackages = [ pkgs.bind ];
  };
in import ./make-test.nix {
  name = "nsd";

  nodes = {
    clientv4 = { lib, nodes, ... }: {
      imports = [ common ];
      networking.nameservers = lib.mkForce [
        nodes.server.config.networking.interfaces.eth1.ipAddress
      ];
      networking.interfaces.eth1.ipAddress = "192.168.0.2";
      networking.interfaces.eth1.prefixLength = 24;
    };

    clientv6 = { lib, nodes, ... }: {
      imports = [ common ];
      networking.nameservers = lib.mkForce [
        nodes.server.config.networking.interfaces.eth1.ipv6Address
      ];
      networking.interfaces.eth1.ipv6Address = "dead:beef::2";
    };

    server = { lib, ... }: {
      imports = [ common ];
      networking.interfaces.eth1.ipAddress = "192.168.0.1";
      networking.interfaces.eth1.prefixLength = 24;
      networking.interfaces.eth1.ipv6Address = "dead:beef::1";
      services.nsd.enable = true;
      services.nsd.interfaces = lib.mkForce [];
      services.nsd.zones."example.com.".data = ''
        @ SOA ns.example.com noc.example.com 666 7200 3600 1209600 3600
        ipv4 A 1.2.3.4
        ipv6 AAAA abcd::eeff
        deleg NS ns.example.com
        ns A 192.168.0.1
        ns AAAA dead:beef::1
      '';
      services.nsd.zones."deleg.example.com.".data = ''
        @ SOA ns.example.com noc.example.com 666 7200 3600 1209600 3600
        @ A 9.8.7.6
        @ AAAA fedc::bbaa
      '';
    };
  };

  testScript = ''
    startAll;

    $clientv4->waitForUnit("network.target");
    $clientv6->waitForUnit("network.target");
    $server->waitForUnit("nsd.service");

    sub assertHost {
      my ($type, $rr, $query, $expected) = @_;
      my $self = $type eq 4 ? $clientv4 : $clientv6;
      my $out = $self->succeed("host -$type -t $rr $query");
      $self->log("output: $out");
      chomp $out;
      die "DNS IPv$type query on $query gave '$out' instead of '$expected'"
        if ($out !~ $expected);
    }

    foreach (4, 6) {
      subtest "ipv$_", sub {
        assertHost($_, "a", "example.com", qr/has no [^ ]+ record/);
        assertHost($_, "aaaa", "example.com", qr/has no [^ ]+ record/);

        assertHost($_, "soa", "example.com", qr/SOA.*?noc\.example\.com/);
        assertHost($_, "a", "ipv4.example.com", qr/address 1.2.3.4$/);
        assertHost($_, "aaaa", "ipv6.example.com", qr/address abcd::eeff$/);

        assertHost($_, "a", "deleg.example.com", qr/address 9.8.7.6$/);
        assertHost($_, "aaaa", "deleg.example.com", qr/address fedc::bbaa$/);
      };
    }
  '';
}
