{
  serverName,
  group,
  baseModule,
  domain ? "example.test",
}:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  name = serverName;
  meta = {
    maintainers = lib.teams.acme.members;
    # Hard timeout in seconds. Average run time is about 100 seconds.
    timeout = 300;
  };

  nodes = {
    # The fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ../common/acme/server ];
      };

    webserver =
      { nodes, ... }:
      {
        imports = [
          ../common/acme/client
          baseModule
        ];
        networking.domain = domain;
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        # Resolve the vhosts the easy way
        networking.hosts."127.0.0.1" = [
          "proxied.${domain}"
          "certchange.${domain}"
          "zeroconf.${domain}"
          "zeroconf2.${domain}"
          "nullroot.${domain}"
        ];

        # OpenSSL will be used for more thorough certificate validation
        environment.systemPackages = [ pkgs.openssl ];

        # Used to determine if service reload was triggered.
        # This does not provide a guarantee that the webserver is finished reloading,
        # to handle that there is retry logic wrapping any connectivity checks.
        systemd.targets."renew-triggered" = {
          wantedBy = [ "${serverName}-config-reload.service" ];
          after = [ "${serverName}-config-reload.service" ];
        };

        security.acme.certs."proxied.${domain}" = {
          listenHTTP = ":8080";
          group = group;
        };

        specialisation = {
          # Test that the web server is correctly reloaded when the cert changes
          certchange.configuration = {
            security.acme.certs."proxied.${domain}".extraDomainNames = [
              "certchange.${domain}"
            ];
          };

          # A useful transitional step before other tests, and tests behaviour
          # of removing an extra domain from a cert.
          certundo.configuration = { };

          # Tests these features:
          #   - enableACME behaves as expected
          #   - serverAliases are appended to extraDomainNames
          #   - Correct routing to the specific virtualHost for a cert
          # Inherits previous test config
          zeroconf.configuration = {
            services.${serverName}.virtualHosts."zeroconf.${domain}" = {
              addSSL = true;
              enableACME = true;
              serverAliases = [ "zeroconf2.${domain}" ];
            };
          };

          # Test that serverAliases are correctly removed which triggers
          # cert regeneration and service reload.
          rmalias.configuration = {
            services.${serverName}.virtualHosts."zeroconf.${domain}" = {
              addSSL = true;
              enableACME = true;
            };
          };

          # Test that "acmeRoot = null" still results in
          # valid cert generation by inheriting defaults.
          nullroot.configuration = {
            security.acme.defaults.listenHTTP = ":8080";
            services.${serverName}.virtualHosts."nullroot.${domain}" = {
              onlySSL = true;
              enableACME = true;
              acmeRoot = null;
            };
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      ${(import ./utils.nix).pythonUtils}

      domain = "${domain}"
      ca_domain = "${nodes.acme.test-support.acme.caDomain}"
      fqdn = f"proxied.{domain}"

      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)

      with subtest("Acquire a cert through a proxied lego"):
          webserver.start()
          webserver.succeed("systemctl is-system-running --wait")
          wait_for_running(webserver)
          download_ca_certs(webserver, ca_domain)
          check_connection(webserver, fqdn)

      with subtest("Can run on selfsigned certificates"):
          # Switch to selfsigned first
          webserver.succeed(f"systemctl clean acme-{fqdn}.service --what=state")
          webserver.succeed(f"systemctl start acme-selfsigned-{fqdn}.service")
          check_issuer(webserver, fqdn, "minica")
          webserver.succeed("systemctl restart ${serverName}-config-reload.service")
          # Check that the web server has picked up the selfsigned cert
          check_connection(webserver, fqdn, minica=True)
          webserver.succeed("systemctl stop renew-triggered.target")
          webserver.succeed(f"systemctl start acme-{fqdn}.service")
          webserver.wait_for_unit("renew-triggered.target")
          check_issuer(webserver, fqdn, "pebble")
          check_connection(webserver, fqdn)

      with subtest("security.acme changes reflect on web server part 1"):
          check_connection(webserver, f"certchange.{domain}", fail=True)
          switch_to(webserver, "certchange")
          webserver.wait_for_unit("renew-triggered.target")
          check_connection(webserver, f"certchange.{domain}")
          check_connection(webserver, fqdn)

      with subtest("security.acme changes reflect on web server part 2"):
          check_connection(webserver, f"certchange.{domain}")
          switch_to(webserver, "certundo")
          webserver.wait_for_unit("renew-triggered.target")
          check_connection(webserver, f"certchange.{domain}", fail=True)
          check_connection(webserver, fqdn)

      with subtest("Zero configuration SSL certificates for a vhost"):
          check_connection(webserver, f"zeroconf.{domain}", fail=True)
          switch_to(webserver, "zeroconf")
          webserver.wait_for_unit("renew-triggered.target")
          check_connection(webserver, f"zeroconf.{domain}")
          check_connection(webserver, f"zeroconf2.{domain}")
          check_connection(webserver, fqdn)

      with subtest("Removing an alias from a vhost"):
          check_connection(webserver, f"zeroconf2.{domain}")
          switch_to(webserver, "rmalias")
          webserver.wait_for_unit("renew-triggered.target")
          check_connection(webserver, f"zeroconf2.{domain}", fail=True)
          check_connection(webserver, f"zeroconf.{domain}")
          check_connection(webserver, fqdn)

      with subtest("Create cert using inherited default validation mechanism"):
          check_connection(webserver, f"nullroot.{domain}", fail=True)
          switch_to(webserver, "nullroot")
          webserver.wait_for_unit("renew-triggered.target")
          check_connection(webserver, f"nullroot.{domain}")
    '';
}
