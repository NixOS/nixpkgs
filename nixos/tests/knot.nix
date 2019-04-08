import ./make-test.nix ({ pkgs, lib, ...} :
let
  common = {
    networking.firewall.enable = false;
    networking.useDHCP = false;
  };
  exampleZone = pkgs.writeTextDir "example.com.zone" ''
      @ SOA ns.example.com. noc.example.com. 2019031301 86400 7200 3600000 172800
      @       NS      ns1
      @       NS      ns2
      ns1     A       192.168.0.1
      ns1     AAAA    fd00::1
      ns2     A       192.168.0.2
      ns2     AAAA    fd00::2
      www     A       192.0.2.1
      www     AAAA    2001:DB8::1
      sub     NS      ns.example.com.
  '';
  delegatedZone = pkgs.writeTextDir "sub.example.com.zone" ''
      @ SOA ns.example.com. noc.example.com. 2019031301 86400 7200 3600000 172800
      @       NS      ns1.example.com.
      @       NS      ns2.example.com.
      @       A       192.0.2.2
      @       AAAA    2001:DB8::2
  '';

  knotZonesEnv = pkgs.buildEnv {
    name = "knot-zones";
    paths = [ exampleZone delegatedZone ];
  };
in {
  name = "knot";

  nodes = {
    master = { lib, ... }: {
      imports = [ common ];
      networking.interfaces.eth1 = {
        ipv4.addresses = lib.mkForce [
          { address = "192.168.0.1"; prefixLength = 24; }
        ];
        ipv6.addresses = lib.mkForce [
          { address = "fd00::1"; prefixLength = 64; }
        ];
      };
      services.knot.enable = true;
      services.knot.extraArgs = [ "-v" ];
      services.knot.extraConfig = ''
        server:
            listen: 0.0.0.0@53
            listen: ::@53

        acl:
          - id: slave_acl
            address: 192.168.0.2
            action: transfer

        remote:
          - id: slave
            address: 192.168.0.2@53

        template:
          - id: default
            storage: ${knotZonesEnv}
            notify: [slave]
            acl: [slave_acl]
            dnssec-signing: on
            # Input-only zone files
            # https://www.knot-dns.cz/docs/2.8/html/operation.html#example-3
            # prevents modification of the zonefiles, since the zonefiles are immutable
            zonefile-sync: -1
            zonefile-load: difference
            journal-content: changes
            # move databases below the state directory, because they need to be writable
            journal-db: /var/lib/knot/journal
            kasp-db: /var/lib/knot/kasp
            timer-db: /var/lib/knot/timer

        zone:
          - domain: example.com
            file: example.com.zone

          - domain: sub.example.com
            file: sub.example.com.zone

        log:
          - target: syslog
            any: info
      '';
    };

    slave = { lib, ... }: {
      imports = [ common ];
      networking.interfaces.eth1 = {
        ipv4.addresses = lib.mkForce [
          { address = "192.168.0.2"; prefixLength = 24; }
        ];
        ipv6.addresses = lib.mkForce [
          { address = "fd00::2"; prefixLength = 64; }
        ];
      };
      services.knot.enable = true;
      services.knot.extraArgs = [ "-v" ];
      services.knot.extraConfig = ''
        server:
            listen: 0.0.0.0@53
            listen: ::@53

        acl:
          - id: notify_from_master
            address: 192.168.0.1
            action: notify

        remote:
          - id: master
            address: 192.168.0.1@53

        template:
          - id: default
            master: master
            acl: [notify_from_master]
            # zonefileless setup
            # https://www.knot-dns.cz/docs/2.8/html/operation.html#example-2
            zonefile-sync: -1
            zonefile-load: none
            journal-content: all
            # move databases below the state directory, because they need to be writable
            journal-db: /var/lib/knot/journal
            kasp-db: /var/lib/knot/kasp
            timer-db: /var/lib/knot/timer

        zone:
          - domain: example.com
            file: example.com.zone

          - domain: sub.example.com
            file: sub.example.com.zone

        log:
          - target: syslog
            any: info
      '';
    };
    client = { lib, nodes, ... }: {
      imports = [ common ];
      networking.interfaces.eth1 = {
        ipv4.addresses = [
          { address = "192.168.0.3"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "fd00::3"; prefixLength = 64; }
        ];
      };
      environment.systemPackages = [ pkgs.knot-dns ];
    };    
  };

  testScript = { nodes, ... }: let 
    master4 = (lib.head nodes.master.config.networking.interfaces.eth1.ipv4.addresses).address;
    master6 = (lib.head nodes.master.config.networking.interfaces.eth1.ipv6.addresses).address;

    slave4 = (lib.head nodes.slave.config.networking.interfaces.eth1.ipv4.addresses).address;
    slave6 = (lib.head nodes.slave.config.networking.interfaces.eth1.ipv6.addresses).address;
  in ''
    startAll;

    $client->waitForUnit("network.target");
    $master->waitForUnit("knot.service");
    $slave->waitForUnit("knot.service");

    sub assertResponse {
      my ($knot, $query_type, $query, $expected) = @_;
      my $out = $client->succeed("khost -t $query_type $query $knot");
      $client->log("$knot replies with: $out");
      chomp $out;
      die "DNS query for $query ($query_type) against $knot gave '$out' instead of '$expected'"
        if ($out !~ $expected);
    }

    foreach ("${master4}", "${master6}", "${slave4}", "${slave6}") {
      subtest $_, sub {
        assertResponse($_, "SOA", "example.com", qr/start of authority.*?noc\.example\.com/);
        assertResponse($_, "A", "example.com", qr/has no [^ ]+ record/);
        assertResponse($_, "AAAA", "example.com", qr/has no [^ ]+ record/);

        assertResponse($_, "A", "www.example.com", qr/address 192.0.2.1$/);
        assertResponse($_, "AAAA", "www.example.com", qr/address 2001:db8::1$/);

        assertResponse($_, "NS", "sub.example.com", qr/nameserver is ns\d\.example\.com.$/);
        assertResponse($_, "A", "sub.example.com", qr/address 192.0.2.2$/);
        assertResponse($_, "AAAA", "sub.example.com", qr/address 2001:db8::2$/);

        assertResponse($_, "RRSIG", "www.example.com", qr/RR set signature is/);
        assertResponse($_, "DNSKEY", "example.com", qr/DNSSEC key is/);
      };
    }
  '';
})
