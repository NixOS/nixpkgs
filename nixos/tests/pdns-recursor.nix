{ lib, pkgs, ... }:

let
  common = {
    networking.firewall.enable = false;
    networking.useDHCP = false;
  };

  authIP = "192.168.1.1";
  serverIP = "192.168.1.2";
  server2IP = "192.168.1.3";
  clientIP = "192.168.1.10";

  iface = ip: {
    networking.interfaces.eth1.ipv4.addresses = lib.mkForce [
      {
        address = ip;
        prefixLength = 24;
      }
    ];
  };

  exampleZone = pkgs.writeText "example.test.zone" ''
    $TTL 3600
    @ IN SOA ns.example.test. admin.example.test. ( 1 3h 1h 1w 1d )
    @ IN NS  ns.example.test.
    ns  IN A 192.168.1.1
    www IN A 192.0.2.1
  '';

  recurseZone = pkgs.writeText "recurse.test.zone" ''
    $TTL 3600
    @ IN SOA ns.recurse.test. admin.recurse.test. ( 1 3h 1h 1w 1d )
    @ IN NS  ns.recurse.test.
    ns   IN A 192.168.1.1
    host IN A 192.0.2.2
  '';

  secureBase = pkgs.writeText "secure.test.zone.in" ''
    $TTL 3600
    @ IN SOA ns.secure.test. admin.secure.test. ( 1 3h 1h 1w 1d )
    @ IN NS  ns.secure.test.
    ns  IN A 192.168.1.1
    www IN A 192.0.2.10
  '';

  # A DNSSEC-signed secure.test served as an "island of trust": the zone is
  # signed with freshly generated keys at build time and the matching DS record
  # is emitted alongside it, so the recursor's trust anchor (added via luaConfig
  # below) always matches the signing key. No runtime key handling, no
  # import-from-derivation.
  signedZone =
    pkgs.runCommand "secure-test-signed"
      {
        nativeBuildInputs = [ pkgs.bind ];
      }
      ''
        mkdir -p $out
        work=$(mktemp -d)
        cd $work
        cp ${secureBase} secure.test.zone
        chmod +w secure.test.zone

        ksk=$(dnssec-keygen -a ECDSAP256SHA256 -f KSK -n ZONE secure.test)
        zsk=$(dnssec-keygen -a ECDSAP256SHA256 -n ZONE secure.test)
        cat "$ksk.key" "$zsk.key" >> secure.test.zone

        dnssec-signzone -o secure.test secure.test.zone
        cp secure.test.zone.signed $out/secure.test.signed

        # Emit just the DS rdata ("<keytag> <algo> <digesttype> <digest>") for addTA.
        dnssec-dsfromkey -2 "$ksk.key" \
          | sed -E 's/^.*DS[[:space:]]+//' \
          | tr -s ' ' \
          | sed -E 's/[[:space:]]+$//' > $out/ds-rdata
      '';

  # Exercise luaConfig: load the trust anchor for the island-of-trust zone and
  # mark the unsigned forwarded zones as insecure (addNTA), so validation does
  # not try to reach the — unreachable, offline — root to prove insecurity.
  serverLua = ''
    local f = assert(io.open("/etc/pdns-recursor/secure-ta"))
    local ds = f:read("*a"):gsub("%s+$", "")
    f:close()
    addTA("secure.test.", ds)
    addNTA("example.test.", "unsigned test zone")
    addNTA("recurse.test.", "unsigned test zone")
  '';

in
{
  name = "powerdns-recursor";
  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  nodes = {
    # Authoritative backend for the forwarded zones (one unsigned zone reached
    # via forwardZones, one via forwardZonesRecurse, and the signed island).
    auth =
      { lib, ... }:
      lib.mkMerge [
        common
        (iface authIP)
        {
          services.bind = {
            enable = true;
            extraOptions = "empty-zones-enable no;";
            zones = [
              {
                name = "example.test";
                master = true;
                file = exampleZone;
              }
              {
                name = "recurse.test";
                master = true;
                file = recurseZone;
              }
              {
                name = "secure.test";
                master = true;
                file = "${signedZone}/secure.test.signed";
              }
            ];
          };
        }
      ];

    # Main recursor: default DNSSEC validation, API on a settings-overridden
    # port, default (localhost-only) API ACL, and a restricted DNS ACL.
    server =
      { lib, ... }:
      lib.mkMerge [
        common
        (iface serverIP)
        {
          environment.systemPackages = [ pkgs.dnsutils ];
          environment.etc."pdns-recursor/secure-ta".source = "${signedZone}/ds-rdata";
          networking.hosts."192.0.2.1" = [ "host.example" ];

          services.pdns-recursor = {
            enable = true;
            exportHosts = true;
            api.enable = true;
            # Only the client may query DNS; server2 (and anyone else) is refused.
            dns.allowFrom = [
              "${clientIP}/32"
              "127.0.0.0/8"
              "::1/128"
            ];
            forwardZones = {
              "example.test" = "${authIP}:53";
            };
            forwardZonesRecurse = {
              "recurse.test" = "${authIP}:53";
              "secure.test" = "${authIP}:53";
            };
            luaConfig = serverLua;
            settings = {
              webservice.api_key = "supersecret";
              # Overrides the api.port default (8082) to prove settings win over
              # the module's mkDefault-derived values.
              webservice.port = 8083;
            };
          };
        }
      ];

    # Alternate recursor exercising the "other mode" of two toggles and the
    # widened API ACL (allow path).
    server2 =
      { lib, ... }:
      lib.mkMerge [
        common
        (iface server2IP)
        {
          environment.systemPackages = [ pkgs.dnsutils ];
          services.pdns-recursor = {
            enable = true;
            api.enable = true;
            dnssecValidation = "off";
            serveRFC1918 = false;
            api.allowFrom = [
              "192.168.1.0/24"
              "127.0.0.1"
              "::1"
            ];
            forwardZonesRecurse = {
              "secure.test" = "${authIP}:53";
            };
            settings.webservice.api_key = "supersecret";
          };
        }
      ];

    # Plain client driving the dig/curl assertions.
    client =
      { lib, ... }:
      lib.mkMerge [
        common
        (iface clientIP)
        {
          environment.systemPackages = [ pkgs.dnsutils ];
          networking.nameservers = lib.mkForce [ serverIP ];
        }
      ];
  };

  testScript = ''
    import re

    start_all()

    auth.wait_for_unit("bind.service")
    server.wait_for_unit("pdns-recursor.service")
    server2.wait_for_unit("pdns-recursor.service")
    client.wait_for_unit("multi-user.target")
    server.wait_for_open_port(53)
    server2.wait_for_open_port(53)

    def ad_flag(out):
        return bool(re.search(r"flags:[^;]*\bad\b", out))

    with subtest("recursor resolves names exported from /etc/hosts"):
        assert "192.0.2.1" in server.succeed("host host.example localhost")

    with subtest("settings override the module's mkDefault (webserver on 8083, not 8082)"):
        server.wait_for_open_port(8083)
        server.fail("curl -f -H 'X-API-Key: supersecret' http://localhost:8082/api/v1/servers")
        server.succeed("curl -f -H 'X-API-Key: supersecret' http://localhost:8083/api/v1/servers")
        server.fail("curl -f http://localhost:8083/api/v1/servers")

    with subtest("metrics are exported"):
        assert "pdns_recursor_" in server.succeed(
            "curl -f -H 'X-API-Key: supersecret' http://localhost:8083/metrics"
        )

    with subtest("api.allowFrom rejects a client outside the allow list"):
        # The default (localhost-only) webserver ACL drops the connection from
        # the client's source address, so curl cannot complete the request.
        client.fail(
            "curl -sf -H 'X-API-Key: supersecret' "
            "http://${serverIP}:8083/api/v1/servers"
        )

    with subtest("api.allowFrom permits a client inside the allow list"):
        server2.wait_for_open_port(8082)
        code = client.succeed(
            "curl -s -o /dev/null -w '%{http_code}' "
            "-H 'X-API-Key: supersecret' http://${server2IP}:8082/api/v1/servers"
        ).strip()
        assert code == "200", f"expected 200 from allowed client, got {code}"

    with subtest("forwardZones resolves via the authoritative backend"):
        out = client.succeed("dig www.example.test @${serverIP}")
        assert "status: NOERROR" in out, out
        assert "192.0.2.1" in out, out

    with subtest("forwardZonesRecurse resolves via the authoritative backend"):
        out = client.succeed("dig host.recurse.test @${serverIP}")
        assert "status: NOERROR" in out, out
        assert "192.0.2.2" in out, out

    with subtest("dns.allowFrom refuses a client outside the allow list"):
        # Queries from a source outside allow-from are dropped, so dig gets no
        # reply (whereas the in-list client resolves fine, above).
        server2.fail("dig +time=3 +tries=1 www.example.test @${serverIP}")

    with subtest("dnssecValidation validates the signed island of trust"):
        out = client.succeed("dig +dnssec www.secure.test @${serverIP}")
        assert "status: NOERROR" in out, out
        assert "192.0.2.10" in out, out
        assert ad_flag(out), f"expected the ad (authenticated data) flag: {out}"

    with subtest("dnssecValidation=off does not set the ad flag"):
        out = client.succeed("dig +dnssec www.secure.test @${server2IP}")
        assert "status: NOERROR" in out, out
        assert not ad_flag(out), f"did not expect the ad flag with validation off: {out}"

    with subtest("serveRFC1918 answers the private reverse zones authoritatively"):
        out = client.succeed("dig -x 10.0.0.1 @${serverIP}")
        assert "status: NXDOMAIN" in out, out

    with subtest("serveRFC1918=false does not answer the private reverse zones"):
        out = client.succeed("dig -x 10.0.0.1 @${server2IP}")
        assert "status: SERVFAIL" in out, out
  '';
}
