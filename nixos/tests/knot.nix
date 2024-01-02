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
      - id: xfr_key
        algorithm: hmac-sha256
        secret: zOYgOgnzx3TGe5J5I/0kxd7gTcxXhLYMEq3Ek3fY37s=
  '';
in {
  name = "knot";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hexa ];
  };


  nodes = {
    primary = { lib, ... }: {
      imports = [ common ];

      # trigger sched_setaffinity syscall
      virtualisation.cores = 2;

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
      services.knot.settings = {
        server = {
          listen = [
            "0.0.0.0@53"
            "::@53"
           ];
          automatic-acl = true;
        };

        acl.secondary_acl = {
          address = "192.168.0.2";
          key = "xfr_key";
          action = "transfer";
        };

        remote.secondary.address = "192.168.0.2@53";

        template.default = {
          storage = knotZonesEnv;
          notify = [ "secondary" ];
          acl = [ "secondary_acl" ];
          dnssec-signing = true;
          # Input-only zone files
          # https://www.knot-dns.cz/docs/2.8/html/operation.html#example-3
          # prevents modification of the zonefiles, since the zonefiles are immutable
          zonefile-sync = -1;
          zonefile-load = "difference";
          journal-content = "changes";
        };

        zone = {
          "example.com".file = "example.com.zone";
          "sub.example.com".file = "sub.example.com.zone";
        };

        log.syslog.any = "info";
      };
    };

    secondary = { lib, ... }: {
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
      services.knot.settings = {
        server = {
          listen = [
            "0.0.0.0@53"
            "::@53"
          ];
          automatic-acl = true;
        };

        remote.primary = {
          address = "192.168.0.1@53";
          key = "xfr_key";
        };

        template.default = {
          master = "primary";
          # zonefileless setup
          # https://www.knot-dns.cz/docs/2.8/html/operation.html#example-2
          zonefile-sync = "-1";
          zonefile-load = "none";
          journal-content = "all";
        };

        zone = {
          "example.com".file = "example.com.zone";
          "sub.example.com".file = "sub.example.com.zone";
        };

        log.syslog.any = "info";
      };
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
    primary4 = (lib.head nodes.primary.config.networking.interfaces.eth1.ipv4.addresses).address;
    primary6 = (lib.head nodes.primary.config.networking.interfaces.eth1.ipv6.addresses).address;

    secondary4 = (lib.head nodes.secondary.config.networking.interfaces.eth1.ipv4.addresses).address;
    secondary6 = (lib.head nodes.secondary.config.networking.interfaces.eth1.ipv6.addresses).address;
  in ''
    import re

    start_all()

    client.wait_for_unit("network.target")
    primary.wait_for_unit("knot.service")
    secondary.wait_for_unit("knot.service")


    def test(host, query_type, query, pattern):
        out = client.succeed(f"khost -t {query_type} {query} {host}").strip()
        client.log(f"{host} replied with: {out}")
        assert re.search(pattern, out), f'Did not match "{pattern}"'


    for host in ("${primary4}", "${primary6}", "${secondary4}", "${secondary6}"):
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

    primary.log(primary.succeed("systemd-analyze security knot.service | grep -v '✓'"))
  '';
})
