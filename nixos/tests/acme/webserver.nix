{
  serverName,
  group,
  baseModule,
  domain,
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

  interactive.sshBackdoor.enable = true;

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
          "zeroconf3.${domain}"
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
          unitConfig.RefuseManualStart = true;
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
            # The default.nix has the server-type dependent config statements
            # to properly set up the proxying. We need a separate port here to
            # avoid hostname issues with the proxy already running on :8080
            security.acme.defaults.listenHTTP = ":8081";
            services.${serverName}.virtualHosts."nullroot.${domain}" = {
              addSSL = true;
              enableACME = true;
              acmeRoot = null;
            };
          };

          # Test that a adding a second virtual host will not trigger
          # other units (account and renewal service for first)
          zeroconf3.configuration = {
            services.${serverName}.virtualHosts = {
              "zeroconf.${domain}" = {
                addSSL = true;
                enableACME = true;
                serverAliases = [ "zeroconf2.${domain}" ];
              };
              "zeroconf3.${domain}" = {
                addSSL = true;
                enableACME = true;
              };
            };
            # We're doing something risky with the combination of the service unit being persistent
            # that could end up that the timers do not trigger properly. Show that timers have the
            # desired effect.
            systemd.timers."acme-renew-zeroconf3.${domain}".timerConfig = {
              OnCalendar = lib.mkForce "*-*-* *:*:0/5";
              AccuracySec = lib.mkForce 0;
              # Skew randomly within the day, per https://letsencrypt.org/docs/integration-guide/.
              RandomizedDelaySec = lib.mkForce 0;
              FixedRandomDelay = lib.mkForce 0;
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

      webserver.start()
      webserver.wait_for_unit("${serverName}.service")

      with subtest("Can run on self-signed certificates"):
          check_issuer(webserver, fqdn, "minica")
          # Check that the web server has picked up the selfsigned cert
          check_connection(webserver, fqdn, minica=True)

      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)

      with subtest("Acquire a cert through a proxied lego"):
        webserver.succeed(f"systemctl start acme-order-renew-{fqdn}.service")
        webserver.wait_for_unit("renew-triggered.target")
        download_ca_certs(webserver, ca_domain)
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

      with subtest("Ensure that adding a second vhost does not trigger first vhost acme units"):
          switch_to(webserver, "zeroconf")
          webserver.wait_for_unit("renew-triggered.target")
          webserver.succeed("journalctl --cursor-file=/tmp/cursor | grep acme")
          switch_to(webserver, "zeroconf3")
          webserver.wait_for_unit("renew-triggered.target")
          output = webserver.succeed("journalctl --cursor-file=/tmp/cursor | grep acme")
          # The new certificate unit gets triggered:
          t.assertIn(f"acme-zeroconf3.{domain}-start", output)
          # The account generation should not be triggered again:
          t.assertNotIn("acme-account-d590213ed52603e9128d.target", output)
          # The other certificates should also not be triggered:
          t.assertNotIn(f"acme-zeroconf.{domain}-start", output)
          t.assertNotIn(f"acme-proxied.{domain}-start", output)
          # Ensure the timer works, due to our shenanigans with
          # RemainAfterExit=true
          webserver.wait_until_succeeds(f"journalctl --cursor-file=/tmp/cursor | grep 'Starting Order (and renew) ACME certificate for zeroconf3.{domain}...'")
    ''
    +
      lib.optionalString
        (config.nodes.webserver.services.nginx.enable && config.nodes.webserver.services.nginx.enableReload)
        ''
          with subtest("Ensure that adding a second vhost does not restart nginx"):
              switch_to(webserver, "zeroconf")
              webserver.wait_for_unit("renew-triggered.target")
              webserver.succeed("journalctl --cursor-file=/tmp/cursor")
              switch_to(webserver, "zeroconf3")
              webserver.wait_for_unit("renew-triggered.target")
              output = webserver.succeed("journalctl --cursor-file=/tmp/cursor")
              t.assertNotIn("Stopping Nginx Web Server...", output)
        '';
}
