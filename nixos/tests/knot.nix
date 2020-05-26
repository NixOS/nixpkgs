import ./make-test-python.nix ({ pkgs, lib, ...} :
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
  # DO NOT USE pkgs.writeText IN PRODUCTION. This put secrets in the nix store!
  tsigFile = pkgs.writeText "tsig.conf" ''
    key:
      - id: slave_key
        algorithm: hmac-sha256
        secret: zOYgOgnzx3TGe5J5I/0kxd7gTcxXhLYMEq3Ek3fY37s=
  '';
in {
  name = "knot";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ hexa ];
  };


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
      services.knot.keyFiles = [ tsigFile ];
      services.knot.extraConfig = ''
        server:
            listen: 0.0.0.0@53
            listen: ::@53

        acl:
          - id: slave_acl
            address: 192.168.0.2
            key: slave_key
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
      services.knot.keyFiles = [ tsigFile ];
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
            key: slave_key

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
    import re

    start_all()

    client.wait_for_unit("network.target")
    master.wait_for_unit("knot.service")
    slave.wait_for_unit("knot.service")


    def test(host, query_type, query, pattern):
        out = client.succeed(f"khost -t {query_type} {query} {host}").strip()
        client.log(f"{host} replied with: {out}")
        assert re.search(pattern, out), f'Did not match "{pattern}"'


    for host in ("${master4}", "${master6}", "${slave4}", "${slave6}"):
        with subtest(f"Interrogate {host}"):
            test(host, "SOA", "example.com", r"start of authority.*noc\.example\.com\.")
            test(host, "A", "example.com", r"has no [^ ]+ record")
            test(host, "AAAA", "example.com", r"has no [^ ]+ record")

            test(host, "A", "www.example.com", r"address 192.0.2.1$")
            test(host, "AAAA", "www.example.com", r"address 2001:db8::1$")

            test(host, "NS", "sub.example.com", r"nameserver is ns\d\.example\.com.$")
            test(host, "A", "sub.example.com", r"address 192.0.2.2$")
            test(host, "AAAA", "sub.example.com", r"address 2001:db8::2$")

            test(host, "RRSIG", "www.example.com", r"RR set signature is")
            test(host, "DNSKEY", "example.com", r"DNSSEC key is")
  '';
})
