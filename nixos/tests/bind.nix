{ lib, ... }:
let
  domain = "example.org";
  shared_cfg =
    { pkgs, ... }:
    {
      services.bind = {
        enable = true;
        extraOptions = "empty-zones-enable no;";

        zones = lib.singleton {
          name = ".";
          master = true;
          file = pkgs.writeText "root.zone" ''
            $TTL 3600
            . IN SOA ns.${domain}. admin.${domain}. ( 1 3h 1h 1w 1d )
            . IN NS ns.${domain}.

            ns.${domain}. IN A    192.168.0.1
            ns.${domain}. IN AAAA abcd::1

            1.0.168.192.in-addr.arpa IN PTR ns.${domain}.
          '';
        };
      };
    };
in
{
  name = "bind";

  nodes =
    let
      domains.${domain} = {
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
          # Dual-stack
          Host-1 = [
            {
              ipv4 = "100.0.1.1";
              ipv6 = "fd7a:115c:a1e0::1";
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
                CNAME = [ "s3" ];
              };
            }
            {
              ipv4 = "10.0.0.1";
              ipv6 = "fdfe:dcba:9877::1";
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
          Host-2 = [
            {
              ipv4 = "100.0.2.2";
              domains.CNAME = [ "aria2" ];
            }
            { }
          ];
          # IPv6-only host
          Host-3 = [
            { ipv6 = "fd7a:115c:a1e0::3"; }
            { }
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
        services.bind.domains = lib.recursiveUpdate domains { ${domain}.mutable = true; };
      };
    };

  testScript = ''
    with subtest("Bind starts and responds"):
      machine.wait_for_unit("bind.service")
      machine.succeed("host 192.168.0.1 127.0.0.1 | grep -qF ns.${domain}")

    with subtest("Bind starts and responds on nondefault port"):
      machineNonDefaultPort.wait_for_unit("bind.service")
      machineNonDefaultPort.succeed("host -p 9053 192.168.0.1 127.0.0.1 | grep -qF ns.${domain}")

    def run_dyn_zone_gen_tests(node):
        node.wait_for_unit("bind.service")
        node.wait_for_open_port(53)

        with subtest(f"[{node.name}] Test Primary Forward Records (Dual Stack)"):
            host_1 = node.succeed("host Host-1.${domain} 127.0.0.1")
            assert "100.0.1.1" in host_1, "Missing first A record for Host-1"
            # assert "10.0.0.1" in host_1, "Missing second A record for Host-1"
            assert "fd7a:115c:a1e0::1" in host_1, "Missing first AAAA record for Host-1"
            # assert "fdfe:dcba:9877::1" in host_1, "Missing second AAAA record for Host-1"

        with subtest(f"[{node.name}] Test Dual-Stack Forward Records (v4-only / v6-only)"):
            v4_rec_a = node.succeed("host v4.${domain} 127.0.0.1")
            assert "100.0.1.1" in v4_rec_a, "Missing first v4-only A record"
            assert "10.0.0.1" in v4_rec_a, "Missing second v4-only A record"
            v4_rec_aaaa = node.succeed("host -t AAAA v4.${domain} 127.0.0.1")
            assert "has no AAAA record" in v4_rec_aaaa, f"Expected NO AAAA records for v4.${domain}, got: {v4_rec_aaaa}"

            v6_rec_aaaa = node.succeed("host v6.${domain} 127.0.0.1")
            assert "fd7a:115c:a1e0::1" in v6_rec_aaaa, "Missing first v6-only AAAA record"
            assert "fdfe:dcba:9877::1" in v6_rec_aaaa, "Missing second v6-only AAAA record"
            v6_rec_a = node.succeed("host -t A v6.${domain} 127.0.0.1")
            assert "has no A record" in v6_rec_a, f"Expected NO A records for v6.${domain}, got: {v6_rec_a}"

        with subtest(f"[{node.name}] Test Single-Stack Forward Records (v4-only / v6-only)"):
            v4_host_a = node.succeed("host Host-2.${domain} 127.0.0.1")
            assert "100.0.2.2" in v4_host_a, "Missing first A record for Host-2"
            # assert "10.0.0.2" in v4_host_a, "Missing second A record for Host-2"
            v4_host_aaaa = node.succeed("host -t AAAA Host-2.${domain} 127.0.0.1")
            assert "has no AAAA record" in v4_host_aaaa, f"Expected NO AAAA records for Host-2, got: {v4_host_aaaa}"

            v6_host_aaaa = node.succeed("host Host-3.${domain} 127.0.0.1")
            assert "fd7a:115c:a1e0::3" in v6_host_aaaa, "Missing first AAAA record for Host-3"
            # assert "fdfe:dcba:9877::3" in v6_host_aaaa, "Missing second AAAA record for Host-3"
            v6_host_a = node.succeed("host -t A Host-3.${domain} 127.0.0.1")
            assert "has no A record" in v6_host_a, f"Expected NO A records for Host-3, got: {v6_host_a}"

        with subtest(f"[{node.name}] Test Subdomains (CNAME / @ / custom labels)"):
            s3_cname = node.succeed("host s3.${domain} 127.0.0.1")
            assert "Host-1.${domain}." in s3_cname, "s3 CNAME did not resolve to Host-1"

            aria2_cname = node.succeed("host aria2.${domain} 127.0.0.1")
            assert "Host-2.${domain}." in aria2_cname, "aria2 CNAME did not resolve to Host-2"

            apex = node.succeed("host ${domain} 127.0.0.1")
            assert "100.0.1.1" in apex, "@ resolution failed for IPv4"
            assert "fd7a:115c:a1e0::1" in apex, "@ resolution failed for IPv6"

            ns1 = node.succeed("host ns1.${domain} 127.0.0.1")
            assert "100.0.1.1" in ns1, "ns1 resolution failed for first IPv4"
            assert "10.0.0.1" in ns1, "ns1 resolution failed for second IPv4"
            assert "fd7a:115c:a1e0::1" in ns1, "ns1 resolution failed for first IPv6"
            assert "fdfe:dcba:9877::1" in ns1, "ns1 resolution failed for second IPv6"

        with subtest(f"[{node.name}] Test Reverse Lookups (IPv4 PTR)"):
            ptr_v4_net_1 = node.succeed("host 100.0.1.1 127.0.0.1")
            assert "Host-1.${domain}." in ptr_v4_net_1, "PTR failed for Host-1"
            ptr_v4_net_2 = node.succeed("host 10.0.0.1 127.0.0.1")
            assert "Host-1.${domain}." in ptr_v4_net_2, "PTR failed for Host-1"

            ptr_v4_only = node.succeed("host 100.0.2.2 127.0.0.1")
            assert "Host-2.${domain}." in ptr_v4_only, "PTR failed for Host-2"

        with subtest(f"[{node.name}] Test Reverse Lookups (IPv6 PTR)"):
            ptr_v6_net_1 = node.succeed("host fd7a:115c:a1e0::1 127.0.0.1")
            assert "Host-1.${domain}." in ptr_v6_net_1, "First IPv6 PTR failed for Host-1"
            ptr_v6_net_2 = node.succeed("host fdfe:dcba:9877::1 127.0.0.1")
            assert "Host-1.${domain}." in ptr_v6_net_2, "Second IPv6 PTR failed for Host-1"

            ptr_v6_host = node.succeed("host fd7a:115c:a1e0::3 127.0.0.1")
            assert "Host-3.${domain}." in ptr_v6_host, "IPv6 PTR failed for Host-3"

    # Execute tests against both standalone VMs
    run_dyn_zone_gen_tests(machineDynamicZoneGen)
    run_dyn_zone_gen_tests(machineDynamicZoneGenMutable)
  '';
}
