{ lib, ... }:
let
  shared_cfg =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.dnsutils ];

      services.bind = {
        enable = true;
        extraOptions = "empty-zones-enable no;";

        zones = lib.singleton {
          name = ".";
          master = true;
          file = pkgs.writeText "root.zone" ''
            $TTL 3600
            . IN SOA ns.example.org. admin.example.org. ( 1 3h 1h 1w 1d )
            . IN NS ns.example.org.

            ns.example.org. IN A    192.168.0.1
            ns.example.org. IN AAAA abcd::1

            1.0.168.192.in-addr.arpa IN PTR ns.example.org.
          '';
        };
      };
    };
in
{
  name = "bind";

  nodes =
    let
      domains."example.com" = {
        bindZoneOptions.master = true;
        networks = [
          {
            v4PrefixLen = 10 / 8;
            v6PrefixLen = 48 / 4;
          }
          {
            v4PrefixLen = 24 / 8;
            v6PrefixLen = 64 / 4;
          }
        ];
        hosts = {
          Host-0 = [
            {
              ipv4 = "100.89.227.22";
              ipv6 = "fd7a:115c:a1e0::1a01:e318";
              domains.CNAME = [ "s3" ];
            }
            {
              ipv4 = "10.0.0.3";
              ipv6 = "fdfe:dcba:9877::3";
            }
          ];
          Host-1 = [
            {
              ipv4 = "100.64.161.20";
              ipv6 = "fd7a:115c:a1e0::cd3a:a114";
              domains = {
                A = [
                  "@"
                  "ns1"
                  "v4"
                ];
                AAAA = [
                  "@"
                  "ns1"
                  "v6"
                ];
                CNAME = [ "aria2" ];
              };
            }
            {
              ipv4 = "10.0.0.2";
              ipv6 = "fdfe:dcba:9877::2";
              domains = {
                A = [
                  "ns1"
                  "v4"
                ];
                AAAA = [
                  "ns1"
                  "v6"
                ];
              };
            }
          ];
          # IPv4-only host
          Host-v4-only = [
            { ipv4 = "100.10.20.30"; }
            { ipv4 = "10.0.0.4"; }
          ];
          # IPv6-only host
          Host-v6-only = [
            { ipv6 = "fd7a:115c:a1e0::1000"; }
            { ipv6 = "fdfe:dcba:9877::4"; }
          ];
        };
      };
    in
    {
      machine = {
        imports = [ shared_cfg ];
      };
      machineNonDefaultPort = {
        imports = [ shared_cfg ];
        services.bind.listenOnPort = 9053;
      };

      machineDynamicZoneGen = {
        imports = [ shared_cfg ];
        services.bind = { inherit domains; };
      };

      machineDynamicZoneGenMutable = {
        imports = [ shared_cfg ];
        services.bind.domains = lib.recursiveUpdate domains { "example.com".mutable = true; };
      };
    };

  testScript = ''
    with subtest("Bind starts and responds"):
      machine.wait_for_unit("bind.service")
      machine.succeed("host 192.168.0.1 127.0.0.1 | grep -qF ns.example.org")

    with subtest("Bind starts and responds on nondefault port"):
      machineNonDefaultPort.wait_for_unit("bind.service")
      machineNonDefaultPort.succeed("host -p 9053 192.168.0.1 127.0.0.1 | grep -qF ns.example.org")

    def run_dyn_zone_gen_tests(node):
        node.wait_for_unit("bind.service")
        node.wait_for_open_port(53)

        with subtest(f"[{node.name}] Test Primary Forward Records (Dual Stack)"):
            # Test IPv4
            host_0 = node.succeed("dig +short @127.0.0.1 Host-0.example.com A")
            assert "100.89.227.22" in host_0, "Missing first A record for Host-0"
            assert "10.0.0.3" in host_0, "Missing second A record for Host-0"
            # Test IPv6
            host_1 = node.succeed("dig +short @127.0.0.1 Host-1.example.com AAAA")
            assert "fd7a:115c:a1e0::cd3a:a114" in host_1, "Missing first AAAA record for Host-1"
            assert "fdfe:dcba:9877::2" in host_1, "Missing second AAAA record for Host-1"

        with subtest(f"[{node.name}] Test Dual-Stack Forward Records (v4-only / v6-only)"):
            # Test IPv4-only record
            v4_only_rec_a = node.succeed("dig +short @127.0.0.1 v4.example.com A")
            assert "100.64.161.20" in v4_only_rec_a, "Missing first v4-only A record for Host-1"
            assert "10.0.0.2" in v4_only_rec_a, "Missing second v4-only A record for Host-1"

            v4_only_rec_aaaa = node.succeed("dig +short @127.0.0.1 v4.example.com AAAA")
            assert v4_only_rec_aaaa.strip() == "", f"Expected NO AAAA records for v4.example.com, got: {v4_only_rec_aaaa}"

            # Test IPv6-only record
            v6_only_rec_aaaa = node.succeed("dig +short @127.0.0.1 v6.example.com AAAA")
            assert "fd7a:115c:a1e0::cd3a:a114" in v6_only_rec_aaaa, "Missing first v6-only AAAA record for Host-1"
            assert "fdfe:dcba:9877::2" in v6_only_rec_aaaa, "Missing second second v6-only AAAA record for Host-1"

            v6_only_rec_a = node.succeed("dig +short @127.0.0.1 v6.example.com A")
            assert v6_only_rec_a.strip() == "", f"Expected NO A records for v6.example.com, got: {v6_only_rec_a}"

        with subtest(f"[{node.name}] Test Single-Stack Forward Records (v4-only / v6-only)"):
            # Test IPv4-only host
            v4_only_a = node.succeed("dig +short @127.0.0.1 Host-v4-only.example.com A")
            assert "100.10.20.30" in v4_only_a, "Missing A record for Host-v4-only"
            assert "10.0.0.4" in v4_only_a, "Missing second A record for Host-v4-only"

            v4_only_aaaa = node.succeed("dig +short @127.0.0.1 Host-v4-only.example.com AAAA")
            assert v4_only_aaaa.strip() == "", f"Expected NO AAAA records for Host-v4-only, got: {v4_only_aaaa}"

            # Test IPv6-only host
            v6_only_aaaa = node.succeed("dig +short @127.0.0.1 Host-v6-only.example.com AAAA")
            assert "fd7a:115c:a1e0::1000" in v6_only_aaaa, "Missing AAAA record for Host-v6-only"
            assert "fdfe:dcba:9877::4" in v6_only_aaaa, "Missing second AAAA record for Host-v6-only"

            v6_only_a = node.succeed("dig +short @127.0.0.1 Host-v6-only.example.com A")
            assert v6_only_a.strip() == "", f"Expected NO A records for Host-v6-only, got: {v6_only_a}"

        with subtest(f"[{node.name}] Test Subdomains (CNAME / @ / custom labels)"):
            # CNAME for s3
            s3_cname = node.succeed("dig +short @127.0.0.1 s3.example.com CNAME")
            assert "Host-0.example.com." in s3_cname, "s3 CNAME did not resolve to Host-0"

            # CNAME for aria2
            aria2_cname = node.succeed("dig +short @127.0.0.1 aria2.example.com CNAME")
            assert "Host-1.example.com." in aria2_cname, "aria2 CNAME did not resolve to Host-1"

            # The '@' domain resolution (example.com root) mapped to Proteus-NUC
            example_a = node.succeed("dig +short @127.0.0.1 example.com A")
            assert "100.64.161.20" in example_a, "@ resolution failed for example.com"

            # The 'ns1' subdomain mapped to Proteus-NUC's A records
            ns1_a = node.succeed("dig +short @127.0.0.1 ns1.example.com A")
            assert "10.0.0.2" in ns1_a, "ns1 resolution failed"

        with subtest(f"[{node.name}] Test Reverse Lookups (IPv4 PTR)"):
            # Network 1: 100.x.x.x
            ptr_v4_net_1 = node.succeed("dig +short @127.0.0.1 -x 100.89.227.22")
            assert "Host-0.example.com." in ptr_v4_net_1, "PTR failed for 100.89.227.22"

            # Network 2: 10.0.0.x
            ptr_v4_net_2 = node.succeed("dig +short @127.0.0.1 -x 10.0.0.2")
            assert "Host-1.example.com." in ptr_v4_net_2, "PTR failed for 10.0.0.2"

            # IPv4-only host
            ptr_v4_only = node.succeed("dig +short @127.0.0.1 -x 100.10.20.30")
            assert "Host-v4-only.example.com." in ptr_v4_only, "PTR failed for 100.10.20.30"

        with subtest(f"[{node.name}] Test Reverse Lookups (IPv6 PTR)"):
            # Network 1: fd7a:115c:a1e0::
            ptr_v6_net_1 = node.succeed("dig +short @127.0.0.1 -x fd7a:115c:a1e0::1a01:e318")
            assert "Host-0.example.com." in ptr_v6_net_1, "IPv6 PTR failed for Host-0"

            # Network 2: fdfe:dcba:9877::
            ptr_v6_net_2 = node.succeed("dig +short @127.0.0.1 -x fdfe:dcba:9877::2")
            assert "Host-1.example.com." in ptr_v6_net_2, "IPv6 PTR failed for Host-1"

            # IPv6-only host
            ptr_v6_only = node.succeed("dig +short @127.0.0.1 -x fd7a:115c:a1e0::1000")
            assert "Host-v6-only.example.com." in ptr_v6_only, "IPv6 PTR failed for Host-v6-only"

    # Execute tests against both standalone VMs
    run_dyn_zone_gen_tests(machineDynamicZoneGen)
    run_dyn_zone_gen_tests(machineDynamicZoneGenMutable)
  '';
}
