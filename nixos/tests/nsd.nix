let
  common = { pkgs, ... }: {
    networking.firewall.enable = false;
    networking.useDHCP = false;
    # for a host utility with IPv6 support
    environment.systemPackages = [ pkgs.bind ];
  };
in import ./make-test.nix ({ pkgs, ...} : {
  name = "nsd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  nodes = {
    clientv4 = { lib, nodes, ... }: {
      imports = [ common ];
      networking.nameservers = lib.mkForce [
        (lib.head nodes.server.config.networking.interfaces.eth1.ipv4.addresses).address
      ];
      networking.interfaces.eth1.ipv4.addresses = [
        { address = "192.168.0.2"; prefixLength = 24; }
      ];
    };

    clientv6 = { lib, nodes, ... }: {
      imports = [ common ];
      networking.nameservers = lib.mkForce [
        (lib.head nodes.server.config.networking.interfaces.eth1.ipv6.addresses).address
      ];
      networking.interfaces.eth1.ipv4.addresses = [
        { address = "dead:beef::2"; prefixLength = 24; }
      ];
    };

    server = { lib, ... }: {
      imports = [ common ];
      networking.interfaces.eth1.ipv4.addresses = [
        { address = "192.168.0.1"; prefixLength = 24; }
      ];
      networking.interfaces.eth1.ipv6.addresses = [
        { address = "dead:beef::1"; prefixLength = 64; }
      ];
      services.nsd.enable = true;
      services.nsd.rootServer = true;
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
      services.nsd.zones.".".data = ''
        @ SOA ns.example.com noc.example.com 666 7200 3600 1209600 3600
        root A 1.8.7.4
        root AAAA acbd::4
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

        assertHost($_, "a", "root", qr/address 1.8.7.4$/);
        assertHost($_, "aaaa", "root", qr/address acbd::4$/);
      };
    }
  '';
})
