# TODO: Test services.acme-dns.api.tls once
# https://github.com/joohoi/acme-dns/issues/214 is fixed.

let
  ipOf = node: node.config.networking.primaryIPAddress;

  common = { lib, nodes, ... }: {
    networking.nameservers = lib.mkForce [ (ipOf nodes.coredns) ];
  };
in

import ./make-test-python.nix ({ lib, ... }: {
  name = "acme-dns";
  meta.maintainers = with lib.maintainers; [ emily yegortimoshenko ];

  nodes = {
    acme.imports = [ common ./common/acme/server ];

    acmedns = { nodes, pkgs, ... }: {
      imports = [ common ];

      networking.firewall = {
        allowedTCPPorts = [ 53 8053 ];
        allowedUDPPorts = [ 53 ];
      };

      services.acme-dns = {
        enable = true;
        api.ip = "0.0.0.0";
        general = {
          domain = "acme-dns.test";
          nsadmin = "hostmaster.acme-dns.test";
          records = [
            "acme-dns.test. A ${ipOf nodes.acmedns}"
            "acme-dns.test. NS acme-dns.test."
          ];
        };
      };
    };

    coredns = { nodes, pkgs, ... }: {
      imports = [ common ];

      networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      services.coredns = {
        enable = true;
        config = ''
          . {
            auto {
              directory /etc/coredns/zones
              reload 1s
            }
          }

          acme-dns.test {
            forward . ${ipOf nodes.acmedns}
          }
        '';
      };

      environment.etc = let
        zone = records: {
          text = ''
            $TTL 1h
            @ SOA coredns.test. hostmaster.example.test. (
              1 ; serial
              1d 2h 1w 1
            )
            @ NS coredns.test.
            ${records}
          '';
        };
        zoneFile = domain: lib.nameValuePair "coredns/zones/db.${domain}";
      in lib.mapAttrs' zoneFile {
        "coredns.test" = zone "@ A ${ipOf nodes.coredns}";
        "acme.test" = zone "@ A ${ipOf nodes.acme}";
        "example.test" = zone "webserver A ${ipOf nodes.webserver}" //
          { mode = "0644"; };
      };
    };

    webserver = { config, pkgs, ... }: {
      imports = [ common ./common/acme/client ];

      services.nginx.enable = true;

      security.acme = {
        server = "https://acme.test/dir";
        certs."example.test" = {
          domain = "*.example.test";
          user = "nginx";
          group = "nginx";
          dnsProvider = "acme-dns";
          credentialsFile = pkgs.writeText "lego-example.test.env" ''
            ACME_DNS_API_BASE=http://acme-dns.test:8053
            ACME_DNS_STORAGE_PATH=/var/lib/acme/example.test/acme-dns.json
          '';
        };
      };

      systemd.targets."acme-finished-example.test" = {};
      systemd.services."acme-example.test" = {
        wants = [ "acme-finished-example.test.target" ];
        before = [ "acme-finished-example.test.target" ];
      };

      specialisation.serving.configuration = {
        networking.firewall.allowedTCPPorts = [ 443 ];

        services.nginx.virtualHosts."webserver.example.test" = {
          onlySSL = true;
          useACMEHost = "example.test";
          locations."/".root = pkgs.runCommand "root" {} ''
            mkdir $out
            echo "hello world" > $out/index.html
          '';
        };
      };
    };

    webclient.imports = [ common ./common/acme/client ];
  };

  testScript = ''
    start_all()

    acme.wait_for_unit("pebble.service")
    acmedns.wait_for_unit("acme-dns.service")
    coredns.wait_for_unit("coredns.service")


    def acme_dns_check_failed(_) -> bool:
        info = webserver.get_unit_info("acme-dns-example.test.service")
        if info["ActiveState"] == "active":
            raise Exception(
                "acme-dns-example.test.service succeeded before the CNAME record was added"
            )
        return info["ActiveState"] == "failed"


    # Get the required CNAME record from the error message.
    retry(acme_dns_check_failed)
    acme_dns_record = webserver.succeed(
        "journalctl --no-pager --output=cat --reverse --lines=1 "
        "--unit=acme-dns-example.test.service "
        "--grep='^  _acme-challenge\\.example\\.test\\. CNAME '"
    ).strip()

    zone_file = "/etc/coredns/zones/db.example.test"
    coredns.succeed(
        f"printf '%s\\n' {acme_dns_record!r} >> {zone_file}",
        f"sed -i 's/1 ; serial/2 ; serial/' {zone_file}",
        "sleep 1",
    )

    webserver.start_job("acme-example.test.service")
    webserver.wait_for_unit("acme-finished-example.test.target")
    webserver.succeed(
        "/run/current-system/specialisation/serving/bin/switch-to-configuration test"
    )

    webclient.wait_for_unit("default.target")
    webclient.succeed("curl https://acme.test:15000/roots/0 > /tmp/ca.crt")
    webclient.succeed("curl https://acme.test:15000/intermediate-keys/0 >> /tmp/ca.crt")
    webclient.succeed(
        "curl --cacert /tmp/ca.crt https://webserver.example.test | grep -qF 'hello world'"
    )
  '';
})
