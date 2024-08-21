{ config, lib, ... }: let

  pkgs = config.node.pkgs;

  commonConfig = ./common/acme/client;

  dnsServerIP = nodes: nodes.dnsserver.networking.primaryIPAddress;

  dnsScript = nodes: let
    dnsAddress = dnsServerIP nodes;
  in pkgs.writeShellScript "dns-hook.sh" ''
    set -euo pipefail
    echo '[INFO]' "[$2]" 'dns-hook.sh' $*
    if [ "$1" = "present" ]; then
      ${pkgs.curl}/bin/curl --data '{"host": "'"$2"'", "value": "'"$3"'"}' http://${dnsAddress}:8055/set-txt
    else
      ${pkgs.curl}/bin/curl --data '{"host": "'"$2"'"}' http://${dnsAddress}:8055/clear-txt
    fi
  '';

  dnsConfig = nodes: {
    dnsProvider = "exec";
    dnsPropagationCheck = false;
    environmentFile = pkgs.writeText "wildcard.env" ''
      EXEC_PATH=${dnsScript nodes}
      EXEC_POLLING_INTERVAL=1
      EXEC_PROPAGATION_TIMEOUT=1
      EXEC_SEQUENCE_INTERVAL=1
    '';
  };

  documentRoot = pkgs.runCommand "docroot" {} ''
    mkdir -p "$out"
    echo hello world > "$out/index.html"
  '';

  vhostBase = {
    forceSSL = true;
    locations."/".root = documentRoot;
  };

  vhostBaseHttpd = {
    forceSSL = true;
    inherit documentRoot;
  };

  simpleConfig = {
    security.acme = {
      certs."http.example.test" = {
        listenHTTP = ":80";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
  };

  # Base specialisation config for testing general ACME features
  webserverBasicConfig = {
    services.nginx.enable = true;
    services.nginx.virtualHosts."a.example.test" = vhostBase // {
      enableACME = true;
    };
  };

  # Generate specialisations for testing a web server
  mkServerConfigs = { server, group, vhostBaseData, extraConfig ? {} }: let
    baseConfig = { nodes, config, specialConfig ? {} }: lib.mkMerge [
      {
        security.acme = {
          defaults = (dnsConfig nodes);
          # One manual wildcard cert
          certs."example.test" = {
            domain = "*.example.test";
          };
        };

        users.users."${config.services."${server}".user}".extraGroups = ["acme"];

        services."${server}" = {
          enable = true;
          virtualHosts = {
            # Run-of-the-mill vhost using HTTP-01 validation
            "${server}-http.example.test" = vhostBaseData // {
              serverAliases = [ "${server}-http-alias.example.test" ];
              enableACME = true;
            };

            # Another which inherits the DNS-01 config
            "${server}-dns.example.test" = vhostBaseData // {
              serverAliases = [ "${server}-dns-alias.example.test" ];
              enableACME = true;
              # Set acmeRoot to null instead of using the default of "/var/lib/acme/acme-challenge"
              # webroot + dnsProvider are mutually exclusive.
              acmeRoot = null;
            };

            # One using the wildcard certificate
            "${server}-wildcard.example.test" = vhostBaseData // {
              serverAliases = [ "${server}-wildcard-alias.example.test" ];
              useACMEHost = "example.test";
            };
          } // (lib.optionalAttrs (server == "nginx") {
            # The nginx module supports using a different key than the hostname
            different-key = vhostBaseData // {
              serverName = "${server}-different-key.example.test";
              serverAliases = [ "${server}-different-key-alias.example.test" ];
              enableACME = true;
            };
          });
        };

        # Used to determine if service reload was triggered
        systemd.targets."test-renew-${server}" = {
          wants = [ "acme-${server}-http.example.test.service" ];
          after = [ "acme-${server}-http.example.test.service" "${server}-config-reload.service" ];
        };
      }
      specialConfig
      extraConfig
    ];
  in {
    "${server}".configuration = { nodes, config, ... }: baseConfig {
      inherit nodes config;
    };

    # Test that server reloads when an alias is removed (and subsequently test removal works in acme)
    "${server}_remove_alias".configuration = { nodes, config, ... }: baseConfig {
      inherit nodes config;
      specialConfig = {
        # Remove an alias, but create a standalone vhost in its place for testing.
        # This configuration results in certificate errors as useACMEHost does not imply
        # append extraDomains, and thus we can validate the SAN is removed.
        services."${server}" = {
          virtualHosts."${server}-http.example.test".serverAliases = lib.mkForce [];
          virtualHosts."${server}-http-alias.example.test" = vhostBaseData // {
            useACMEHost = "${server}-http.example.test";
          };
        };
      };
    };

    # Test that the server reloads when only the acme configuration is changed.
    "${server}_change_acme_conf".configuration = { nodes, config, ... }: baseConfig {
      inherit nodes config;
      specialConfig = {
        security.acme.certs."${server}-http.example.test" = {
          keyType = "ec384";
          # Also test that postRun is exec'd as root
          postRun = "id | grep root";
        };
      };
    };
  };

in {
  name = "acme";
  meta = {
    maintainers = lib.teams.acme.members;
    # Hard timeout in seconds. Average run time is about 7 minutes.
    timeout = 1800;
  };

  nodes = {
    # The fake ACME server which will respond to client requests
    acme = { nodes, ... }: {
      imports = [ ./common/acme/server ];
      networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];
    };

    # A fake DNS server which can be configured with records as desired
    # Used to test DNS-01 challenge
    dnsserver = { nodes, ... }: {
      networking.firewall.allowedTCPPorts = [ 8055 53 ];
      networking.firewall.allowedUDPPorts = [ 53 ];
      systemd.services.pebble-challtestsrv = {
        enable = true;
        description = "Pebble ACME challenge test server";
        wantedBy = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.pebble}/bin/pebble-challtestsrv -dns01 ':53' -defaultIPv6 '' -defaultIPv4 '${nodes.webserver.networking.primaryIPAddress}'";
          # Required to bind on privileged ports.
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        };
      };
    };

    # A web server which will be the node requesting certs
    webserver = { nodes, config, ... }: {
      imports = [ commonConfig ];
      networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];
      networking.firewall.allowedTCPPorts = [ 80 443 ];

      # OpenSSL will be used for more thorough certificate validation
      environment.systemPackages = [ pkgs.openssl ];

      # Set log level to info so that we can see when the service is reloaded
      services.nginx.logError = "stderr info";

      specialisation = {
        # Tests HTTP-01 verification using Lego's built-in web server
        http01lego.configuration = simpleConfig;

        # account hash generation with default server from <= 23.11
        http01lego_legacyAccountHash.configuration = lib.mkMerge [
          simpleConfig
          {
            security.acme.defaults.server = lib.mkForce null;
          }
        ];

        renew.configuration = lib.mkMerge [
          simpleConfig
          {
            # Pebble provides 5 year long certs,
            # needs to be higher than that to test renewal
            security.acme.certs."http.example.test".validMinDays = 9999;
          }
        ];

        # Tests that account creds can be safely changed.
        accountchange.configuration = lib.mkMerge [
          simpleConfig
          {
            security.acme.certs."http.example.test".email = "admin@example.test";
          }
        ];

        # First derivation used to test general ACME features
        general.configuration = { ... }: let
          caDomain = nodes.acme.test-support.acme.caDomain;
          email = config.security.acme.defaults.email;
          # Exit 99 to make it easier to track if this is the reason a renew failed
          accountCreateTester = ''
            test -e accounts/${caDomain}/${email}/account.json || exit 99
          '';
        in lib.mkMerge [
          webserverBasicConfig
          {
            # Used to test that account creation is collated into one service.
            # These should not run until after acme-finished-a.example.test.target
            systemd.services."b.example.test".preStart = accountCreateTester;
            systemd.services."c.example.test".preStart = accountCreateTester;

            services.nginx.virtualHosts."b.example.test" = vhostBase // {
              enableACME = true;
            };
            services.nginx.virtualHosts."c.example.test" = vhostBase // {
              enableACME = true;
            };
          }
        ];

        # Test OCSP Stapling
        ocsp_stapling.configuration = { ... }: lib.mkMerge [
          webserverBasicConfig
          {
            security.acme.certs."a.example.test".ocspMustStaple = true;
            services.nginx.virtualHosts."a.example.test" = {
              extraConfig = ''
                ssl_stapling on;
                ssl_stapling_verify on;
              '';
            };
          }
        ];

        # Validate service relationships by adding a slow start service to nginx' wants.
        # Reproducer for https://github.com/NixOS/nixpkgs/issues/81842
        slow_startup.configuration = { ... }: lib.mkMerge [
          webserverBasicConfig
          {
            systemd.services.my-slow-service = {
              wantedBy = [ "multi-user.target" "nginx.service" ];
              before = [ "nginx.service" ];
              preStart = "sleep 5";
              script = "${pkgs.python3}/bin/python -m http.server";
            };

            services.nginx.virtualHosts."slow.example.test" = {
              forceSSL = true;
              enableACME = true;
              locations."/".proxyPass = "http://localhost:8000";
            };
          }
        ];

        concurrency_limit.configuration = {pkgs, ...}: lib.mkMerge [
          webserverBasicConfig {
            security.acme.maxConcurrentRenewals = 1;

            services.nginx.virtualHosts = {
              "f.example.test" = vhostBase // {
                enableACME = true;
              };
              "g.example.test" = vhostBase // {
                enableACME = true;
              };
              "h.example.test" = vhostBase // {
                enableACME = true;
              };
            };

            systemd.services = {
              # check for mutual exclusion of starting renew services
              "acme-f.example.test".serviceConfig.ExecPreStart = "+" + (pkgs.writeShellScript "test-f" ''
                test "$(systemctl is-active acme-{g,h}.example.test.service | grep activating | wc -l)" -le 0
                '');
              "acme-g.example.test".serviceConfig.ExecPreStart = "+" + (pkgs.writeShellScript "test-g" ''
                test "$(systemctl is-active acme-{f,h}.example.test.service | grep activating | wc -l)" -le 0
                '');
              "acme-h.example.test".serviceConfig.ExecPreStart = "+" + (pkgs.writeShellScript "test-h" ''
                test "$(systemctl is-active acme-{g,f}.example.test.service | grep activating | wc -l)" -le 0
                '');
              };
          }
        ];

        # Test lego internal server (listenHTTP option)
        # Also tests useRoot option
        lego_server.configuration = { ... }: {
          security.acme.useRoot = true;
          security.acme.certs."lego.example.test" = {
            listenHTTP = ":80";
            group = "nginx";
          };
          services.nginx.enable = true;
          services.nginx.virtualHosts."lego.example.test" = {
            useACMEHost = "lego.example.test";
            onlySSL = true;
          };
        };

      # Test compatibility with Caddy
      # It only supports useACMEHost, hence not using mkServerConfigs
      } // (let
        baseCaddyConfig = { nodes, config, ... }: {
          security.acme = {
            defaults = (dnsConfig nodes);
            # One manual wildcard cert
            certs."example.test" = {
              domain = "*.example.test";
            };
          };

          users.users."${config.services.caddy.user}".extraGroups = ["acme"];

          services.caddy = {
            enable = true;
            virtualHosts."a.example.test" = {
              useACMEHost = "example.test";
              extraConfig = ''
                root * ${documentRoot}
              '';
            };
          };
        };
      in {
        caddy.configuration = baseCaddyConfig;

        # Test that the server reloads when only the acme configuration is changed.
        "caddy_change_acme_conf".configuration = { nodes, config, ... }: lib.mkMerge [
          (baseCaddyConfig {
            inherit nodes config;
          })
          {
            security.acme.certs."example.test" = {
              keyType = "ec384";
            };
          }
        ];

      # Test compatibility with Nginx
      }) // (mkServerConfigs {
          server = "nginx";
          group = "nginx";
          vhostBaseData = vhostBase;
        })

      # Test compatibility with Apache HTTPD
        // (mkServerConfigs {
          server = "httpd";
          group = "wwwrun";
          vhostBaseData = vhostBaseHttpd;
          extraConfig = {
            services.httpd.adminAddr = config.security.acme.defaults.email;
          };
        });
    };

    # The client will be used to curl the webserver to validate configuration
    client = { nodes, ... }: {
      imports = [ commonConfig ];
      networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];

      # OpenSSL will be used for more thorough certificate validation
      environment.systemPackages = [ pkgs.openssl ];
    };
  };

  testScript = { nodes, ... }:
    let
      caDomain = nodes.acme.test-support.acme.caDomain;
    in
    # Note, wait_for_unit does not work for oneshot services that do not have RemainAfterExit=true,
    # this is because a oneshot goes from inactive => activating => inactive, and never
    # reaches the active state. Targets do not have this issue.
    ''
      import time


      TOTAL_RETRIES = 20


      class BackoffTracker(object):
          delay = 1
          increment = 1

          def handle_fail(self, retries, message) -> int:
              assert retries < TOTAL_RETRIES, message

              print(f"Retrying in {self.delay}s, {retries + 1}/{TOTAL_RETRIES}")
              time.sleep(self.delay)

              # Only increment after the first try
              if retries == 0:
                  self.delay += self.increment
                  self.increment *= 2

              return retries + 1


      backoff = BackoffTracker()


      def switch_to(node, name, allow_fail=False):
          # On first switch, this will create a symlink to the current system so that we can
          # quickly switch between derivations
          root_specs = "/tmp/specialisation"
          node.execute(
            f"test -e {root_specs}"
            f" || ln -s $(readlink /run/current-system)/specialisation {root_specs}"
          )

          switcher_path = f"/run/current-system/specialisation/{name}/bin/switch-to-configuration"
          rc, _ = node.execute(f"test -e '{switcher_path}'")
          if rc > 0:
              switcher_path = f"/tmp/specialisation/{name}/bin/switch-to-configuration"

          if not allow_fail:
            node.succeed(
                f"{switcher_path} test"
            )
          else:
            node.execute(
                f"{switcher_path} test"
            )


      # Ensures the issuer of our cert matches the chain
      # and matches the issuer we expect it to be.
      # It's a good validation to ensure the cert.pem and fullchain.pem
      # are not still selfsigned after verification
      def check_issuer(node, cert_name, issuer):
          for fname in ("cert.pem", "fullchain.pem"):
              actual_issuer = node.succeed(
                  f"openssl x509 -noout -issuer -in /var/lib/acme/{cert_name}/{fname}"
              ).partition("=")[2]
              print(f"{fname} issuer: {actual_issuer}")
              assert issuer.lower() in actual_issuer.lower()


      # Ensure cert comes before chain in fullchain.pem
      def check_fullchain(node, cert_name):
          subject_data = node.succeed(
              f"openssl crl2pkcs7 -nocrl -certfile /var/lib/acme/{cert_name}/fullchain.pem"
              " | openssl pkcs7 -print_certs -noout"
          )
          for line in subject_data.lower().split("\n"):
              if "subject" in line:
                  print(f"First subject in fullchain.pem: {line}")
                  assert cert_name.lower() in line
                  return

          assert False


      def check_connection(node, domain, retries=0):
          result = node.succeed(
              "openssl s_client -brief -verify 2 -CAfile /tmp/ca.crt"
              f" -servername {domain} -connect {domain}:443 < /dev/null 2>&1"
          )

          for line in result.lower().split("\n"):
              if "verification" in line and "error" in line:
                  retries = backoff.handle_fail(retries, f"Failed to connect to https://{domain}")
                  return check_connection(node, domain, retries)


      def check_connection_key_bits(node, domain, bits, retries=0):
          result = node.succeed(
              "openssl s_client -CAfile /tmp/ca.crt"
              f" -servername {domain} -connect {domain}:443 < /dev/null"
              " | openssl x509 -noout -text | grep -i Public-Key"
          )
          print("Key type:", result)

          if bits not in result:
              retries = backoff.handle_fail(retries, f"Did not find expected number of bits ({bits}) in key")
              return check_connection_key_bits(node, domain, bits, retries)


      def check_stapling(node, domain, retries=0):
          # Pebble doesn't provide a full OCSP responder, so just check the URL
          result = node.succeed(
              "openssl s_client -CAfile /tmp/ca.crt"
              f" -servername {domain} -connect {domain}:443 < /dev/null"
              " | openssl x509 -noout -ocsp_uri"
          )
          print("OCSP Responder URL:", result)

          if "${caDomain}:4002" not in result.lower():
              retries = backoff.handle_fail(retries, "OCSP Stapling check failed")
              return check_stapling(node, domain, retries)


      def download_ca_certs(node, retries=0):
          exit_code, _ = node.execute("curl https://${caDomain}:15000/roots/0 > /tmp/ca.crt")
          exit_code_2, _ = node.execute(
              "curl https://${caDomain}:15000/intermediate-keys/0 >> /tmp/ca.crt"
          )

          if exit_code + exit_code_2 > 0:
              retries = backoff.handle_fail(retries, "Failed to connect to pebble to download root CA certs")
              return download_ca_certs(node, retries)


      start_all()

      dnsserver.wait_for_unit("pebble-challtestsrv.service")
      client.wait_for_unit("default.target")

      client.succeed(
          'curl --data \'{"host": "${caDomain}", "addresses": ["${nodes.acme.networking.primaryIPAddress}"]}\' http://${dnsServerIP nodes}:8055/add-a'
      )

      acme.systemctl("start network-online.target")
      acme.wait_for_unit("network-online.target")
      acme.wait_for_unit("pebble.service")

      download_ca_certs(client)

      # Perform http-01 w/ lego test first
      with subtest("Can request certificate with Lego's built in web server"):
          switch_to(webserver, "http01lego")
          webserver.wait_for_unit("acme-finished-http.example.test.target")
          check_fullchain(webserver, "http.example.test")
          check_issuer(webserver, "http.example.test", "pebble")

      # Perform account hash test
      with subtest("Assert that account hash didn't unexpectedly change"):
          hash = webserver.succeed("ls /var/lib/acme/.lego/accounts/")
          print("Account hash: " + hash)
          assert hash.strip() == "d590213ed52603e9128d"

      # Perform renewal test
      with subtest("Can renew certificates when they expire"):
          hash = webserver.succeed("sha256sum /var/lib/acme/http.example.test/cert.pem")
          switch_to(webserver, "renew")
          webserver.wait_for_unit("acme-finished-http.example.test.target")
          check_fullchain(webserver, "http.example.test")
          check_issuer(webserver, "http.example.test", "pebble")
          hash_after = webserver.succeed("sha256sum /var/lib/acme/http.example.test/cert.pem")
          assert hash != hash_after

      # Perform account change test
      with subtest("Handles email change correctly"):
          hash = webserver.succeed("sha256sum /var/lib/acme/http.example.test/cert.pem")
          switch_to(webserver, "accountchange")
          webserver.wait_for_unit("acme-finished-http.example.test.target")
          check_fullchain(webserver, "http.example.test")
          check_issuer(webserver, "http.example.test", "pebble")
          hash_after = webserver.succeed("sha256sum /var/lib/acme/http.example.test/cert.pem")
          # Has to do a full run to register account, which creates new certs.
          assert hash != hash_after

      # Perform general tests
      switch_to(webserver, "general")

      with subtest("Can request certificate with HTTP-01 challenge"):
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_fullchain(webserver, "a.example.test")
          check_issuer(webserver, "a.example.test", "pebble")
          webserver.wait_for_unit("nginx.service")
          check_connection(client, "a.example.test")

      with subtest("Runs 1 cert for account creation before others"):
          webserver.wait_for_unit("acme-finished-b.example.test.target")
          webserver.wait_for_unit("acme-finished-c.example.test.target")
          check_connection(client, "b.example.test")
          check_connection(client, "c.example.test")

      with subtest("Certificates and accounts have safe + valid permissions"):
          # Nginx will set the group appropriately when enableACME is used
          group = "nginx"
          webserver.succeed(
              f"test $(stat -L -c '%a %U %G' /var/lib/acme/a.example.test/*.pem | tee /dev/stderr | grep '640 acme {group}' | wc -l) -eq 5"
          )
          webserver.succeed(
              f"test $(stat -L -c '%a %U %G' /var/lib/acme/.lego/a.example.test/**/a.example.test* | tee /dev/stderr | grep '600 acme {group}' | wc -l) -eq 4"
          )
          webserver.succeed(
              f"test $(stat -L -c '%a %U %G' /var/lib/acme/a.example.test | tee /dev/stderr | grep '750 acme {group}' | wc -l) -eq 1"
          )
          webserver.succeed(
              f"test $(find /var/lib/acme/accounts -type f -exec stat -L -c '%a %U %G' {{}} \\; | tee /dev/stderr | grep -v '600 acme {group}' | wc -l) -eq 0"
          )

      # Selfsigned certs tests happen late so we aren't fighting the system init triggering cert renewal
      with subtest("Can generate valid selfsigned certs"):
          webserver.succeed("systemctl clean acme-a.example.test.service --what=state")
          webserver.succeed("systemctl start acme-selfsigned-a.example.test.service")
          check_fullchain(webserver, "a.example.test")
          check_issuer(webserver, "a.example.test", "minica")
          # Check selfsigned permissions
          webserver.succeed(
              f"test $(stat -L -c '%a %U %G' /var/lib/acme/a.example.test/*.pem | tee /dev/stderr | grep '640 acme {group}' | wc -l) -eq 5"
          )
          # Will succeed if nginx can load the certs
          webserver.succeed("systemctl start nginx-config-reload.service")

      with subtest("Correctly implements OCSP stapling"):
          switch_to(webserver, "ocsp_stapling")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_stapling(client, "a.example.test")

      with subtest("Can request certificate with HTTP-01 using lego's internal web server"):
          switch_to(webserver, "lego_server")
          webserver.wait_for_unit("acme-finished-lego.example.test.target")
          webserver.wait_for_unit("nginx.service")
          webserver.succeed("echo HENLO && systemctl cat nginx.service")
          webserver.succeed("test \"$(stat -c '%U' /var/lib/acme/* | uniq)\" = \"root\"")
          check_connection(client, "a.example.test")
          check_connection(client, "lego.example.test")

      with subtest("Can request certificate with HTTP-01 when nginx startup is delayed"):
          webserver.execute("systemctl stop nginx")
          switch_to(webserver, "slow_startup")
          webserver.wait_for_unit("acme-finished-slow.example.test.target")
          check_issuer(webserver, "slow.example.test", "pebble")
          webserver.wait_for_unit("nginx.service")
          check_connection(client, "slow.example.test")

      with subtest("Can limit concurrency of running renewals"):
          switch_to(webserver, "concurrency_limit")
          webserver.wait_for_unit("acme-finished-f.example.test.target")
          webserver.wait_for_unit("acme-finished-g.example.test.target")
          webserver.wait_for_unit("acme-finished-h.example.test.target")
          check_connection(client, "f.example.test")
          check_connection(client, "g.example.test")
          check_connection(client, "h.example.test")

      with subtest("Works with caddy"):
          switch_to(webserver, "caddy")
          webserver.wait_for_unit("acme-finished-example.test.target")
          webserver.wait_for_unit("caddy.service")
          # FIXME reloading caddy is not sufficient to load new certs.
          # Restart it manually until this is fixed.
          webserver.succeed("systemctl restart caddy.service")
          check_connection(client, "a.example.test")

      with subtest("security.acme changes reflect on caddy"):
          switch_to(webserver, "caddy_change_acme_conf")
          webserver.wait_for_unit("acme-finished-example.test.target")
          webserver.wait_for_unit("caddy.service")
          # FIXME reloading caddy is not sufficient to load new certs.
          # Restart it manually until this is fixed.
          webserver.succeed("systemctl restart caddy.service")
          check_connection_key_bits(client, "a.example.test", "384")

      common_domains = ["http", "dns", "wildcard"]
      for server, logsrc, domains in [
          ("nginx", "journalctl -n 30 -u nginx.service", common_domains + ["different-key"]),
          ("httpd", "tail -n 30 /var/log/httpd/*.log", common_domains),
      ]:
          wait_for_server = lambda: webserver.wait_for_unit(f"{server}.service")
          with subtest(f"Works with {server}"):
              try:
                  switch_to(webserver, server)
                  for domain in domains:
                      if domain != "wildcard":
                          webserver.wait_for_unit(
                              f"acme-finished-{server}-{domain}.example.test.target"
                          )
              except Exception as err:
                  _, output = webserver.execute(
                      f"{logsrc} && ls -al /var/lib/acme/acme-challenge"
                  )
                  print(output)
                  raise err

              wait_for_server()

              for domain in domains:
                  if domain != "wildcard":
                      check_issuer(webserver, f"{server}-{domain}.example.test", "pebble")
              for domain in domains:
                  check_connection(client, f"{server}-{domain}.example.test")
                  check_connection(client, f"{server}-{domain}-alias.example.test")

          test_domain = f"{server}-{domains[0]}.example.test"

          with subtest(f"Can reload {server} when timer triggers renewal"):
              # Switch to selfsigned first
              webserver.succeed(f"systemctl clean acme-{test_domain}.service --what=state")
              webserver.succeed(f"systemctl start acme-selfsigned-{test_domain}.service")
              check_issuer(webserver, test_domain, "minica")
              webserver.succeed(f"systemctl start {server}-config-reload.service")
              webserver.succeed(f"systemctl start test-renew-{server}.target")
              check_issuer(webserver, test_domain, "pebble")
              check_connection(client, test_domain)

          with subtest("Can remove an alias from a domain + cert is updated"):
              test_alias = f"{server}-{domains[0]}-alias.example.test"
              switch_to(webserver, f"{server}_remove_alias")
              webserver.wait_for_unit(f"acme-finished-{test_domain}.target")
              wait_for_server()
              check_connection(client, test_domain)
              rc, _s = client.execute(
                  f"openssl s_client -CAfile /tmp/ca.crt -connect {test_alias}:443"
                  " </dev/null 2>/dev/null | openssl x509 -noout -text"
                  f" | grep DNS: | grep {test_alias}"
              )
              assert rc > 0, "Removed extraDomainName was not removed from the cert"

          with subtest("security.acme changes reflect on web server"):
              # Switch back to normal server config first, reset everything.
              switch_to(webserver, server)
              wait_for_server()
              switch_to(webserver, f"{server}_change_acme_conf")
              webserver.wait_for_unit(f"acme-finished-{test_domain}.target")
              wait_for_server()
              check_connection_key_bits(client, test_domain, "384")

      # Perform http-01 w/ lego test again, but using the pre-24.05 account hashing
      # (see https://github.com/NixOS/nixpkgs/pull/317257)
      with subtest("Check account hashing compatibility with pre-24.05 settings"):
          webserver.succeed("rm -rf /var/lib/acme/.lego/accounts/*")
          switch_to(webserver, "http01lego_legacyAccountHash", allow_fail=True)
          # unit is failed, but in a way that this throws no exception:
          try:
            webserver.wait_for_unit("acme-finished-http.example.test.target")
          except Exception:
            # The unit is allowed – or even expected – to fail due to not being able to
            # reach the actual letsencrypt server. We only use it for serialising the
            # test execution, such that the account check is done after the service run
            # involving the account creation has been executed at least once.
            pass
          hash = webserver.succeed("ls /var/lib/acme/.lego/accounts/")
          print("Account hash: " + hash)
          assert hash.strip() == "1ccf607d9aa280e9af00"
    '';
}
