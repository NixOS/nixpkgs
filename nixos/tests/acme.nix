let
  commonConfig = ./common/acme/client;

  dnsServerIP = nodes: nodes.dnsserver.config.networking.primaryIPAddress;

  dnsScript = {pkgs, nodes}: let
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

  documentRoot = pkgs: pkgs.runCommand "docroot" {} ''
    mkdir -p "$out"
    echo hello world > "$out/index.html"
  '';

  vhostBase = pkgs: {
    forceSSL = true;
    locations."/".root = documentRoot pkgs;
  };

in import ./make-test-python.nix ({ lib, ... }: {
  name = "acme";
  meta.maintainers = lib.teams.acme.members;

  nodes = {
    # The fake ACME server which will respond to client requests
    acme = { nodes, lib, ... }: {
      imports = [ ./common/acme/server ];
      networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];
    };

    # A fake DNS server which can be configured with records as desired
    # Used to test DNS-01 challenge
    dnsserver = { nodes, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 8055 53 ];
      networking.firewall.allowedUDPPorts = [ 53 ];
      systemd.services.pebble-challtestsrv = {
        enable = true;
        description = "Pebble ACME challenge test server";
        wantedBy = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.pebble}/bin/pebble-challtestsrv -dns01 ':53' -defaultIPv6 '' -defaultIPv4 '${nodes.webserver.config.networking.primaryIPAddress}'";
          # Required to bind on privileged ports.
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        };
      };
    };

    # A web server which will be the node requesting certs
    webserver = { pkgs, nodes, lib, config, ... }: {
      imports = [ commonConfig ];
      networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];
      networking.firewall.allowedTCPPorts = [ 80 443 ];

      # OpenSSL will be used for more thorough certificate validation
      environment.systemPackages = [ pkgs.openssl ];

      # Set log level to info so that we can see when the service is reloaded
      services.nginx.enable = true;
      services.nginx.logError = "stderr info";

      # First tests configure a basic cert and run a bunch of openssl checks
      services.nginx.virtualHosts."a.example.test" = (vhostBase pkgs) // {
        enableACME = true;
      };

      # Used to determine if service reload was triggered
      systemd.targets.test-renew-nginx = {
        wants = [ "acme-a.example.test.service" ];
        after = [ "acme-a.example.test.service" "nginx-config-reload.service" ];
      };

      # Test that account creation is collated into one service
      specialisation.account-creation.configuration = { nodes, pkgs, lib, ... }: let
        email = "newhostmaster@example.test";
        caDomain = nodes.acme.config.test-support.acme.caDomain;
        # Exit 99 to make it easier to track if this is the reason a renew failed
        testScript = ''
          test -e accounts/${caDomain}/${email}/account.json || exit 99
        '';
      in {
        security.acme.email = lib.mkForce email;
        systemd.services."b.example.test".preStart = testScript;
        systemd.services."c.example.test".preStart = testScript;

        services.nginx.virtualHosts."b.example.test" = (vhostBase pkgs) // {
          enableACME = true;
        };
        services.nginx.virtualHosts."c.example.test" = (vhostBase pkgs) // {
          enableACME = true;
        };
      };

      # Cert config changes will not cause the nginx configuration to change.
      # This tests that the reload service is correctly triggered.
      # It also tests that postRun is exec'd as root
      specialisation.cert-change.configuration = { pkgs, ... }: {
        security.acme.certs."a.example.test".keyType = "ec384";
        security.acme.certs."a.example.test".postRun = ''
          set -euo pipefail
          touch test
          chown root:root test
          echo testing > test
        '';
      };

      # Now adding an alias to ensure that the certs are updated
      specialisation.nginx-aliases.configuration = { pkgs, ... }: {
        services.nginx.virtualHosts."a.example.test" = {
          serverAliases = [ "b.example.test" ];
        };
      };

      # Test OCSP Stapling
      specialisation.ocsp-stapling.configuration = { pkgs, ... }: {
        security.acme.certs."a.example.test" = {
          ocspMustStaple = true;
        };
        services.nginx.virtualHosts."a.example.com" = {
          extraConfig = ''
            ssl_stapling on;
            ssl_stapling_verify on;
          '';
        };
      };

      # Test using Apache HTTPD
      specialisation.httpd-aliases.configuration = { pkgs, config, lib, ... }: {
        services.nginx.enable = lib.mkForce false;
        services.httpd.enable = true;
        services.httpd.adminAddr = config.security.acme.email;
        services.httpd.virtualHosts."c.example.test" = {
          serverAliases = [ "d.example.test" ];
          forceSSL = true;
          enableACME = true;
          documentRoot = documentRoot pkgs;
        };

        # Used to determine if service reload was triggered
        systemd.targets.test-renew-httpd = {
          wants = [ "acme-c.example.test.service" ];
          after = [ "acme-c.example.test.service" "httpd-config-reload.service" ];
        };
      };

      # Validation via DNS-01 challenge
      specialisation.dns-01.configuration = { pkgs, config, nodes, ... }: {
        security.acme.certs."example.test" = {
          domain = "*.example.test";
          group = config.services.nginx.group;
          dnsProvider = "exec";
          dnsPropagationCheck = false;
          credentialsFile = pkgs.writeText "wildcard.env" ''
            EXEC_PATH=${dnsScript { inherit pkgs nodes; }}
          '';
        };

        services.nginx.virtualHosts."dns.example.test" = (vhostBase pkgs) // {
          useACMEHost = "example.test";
        };
      };

      # Validate service relationships by adding a slow start service to nginx' wants.
      # Reproducer for https://github.com/NixOS/nixpkgs/issues/81842
      specialisation.slow-startup.configuration = { pkgs, config, nodes, lib, ... }: {
        systemd.services.my-slow-service = {
          wantedBy = [ "multi-user.target" "nginx.service" ];
          before = [ "nginx.service" ];
          preStart = "sleep 5";
          script = "${pkgs.python3}/bin/python -m http.server";
        };

        services.nginx.virtualHosts."slow.example.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://localhost:8000";
        };
      };
    };

    # The client will be used to curl the webserver to validate configuration
    client = {nodes, lib, pkgs, ...}: {
      imports = [ commonConfig ];
      networking.nameservers = lib.mkForce [ (dnsServerIP nodes) ];

      # OpenSSL will be used for more thorough certificate validation
      environment.systemPackages = [ pkgs.openssl ];
    };
  };

  testScript = {nodes, ...}:
    let
      caDomain = nodes.acme.config.test-support.acme.caDomain;
      newServerSystem = nodes.webserver.config.system.build.toplevel;
      switchToNewServer = "${newServerSystem}/bin/switch-to-configuration test";
    in
    # Note, wait_for_unit does not work for oneshot services that do not have RemainAfterExit=true,
    # this is because a oneshot goes from inactive => activating => inactive, and never
    # reaches the active state. Targets do not have this issue.

    ''
      import time


      has_switched = False


      def switch_to(node, name):
          global has_switched
          if has_switched:
              node.succeed(
                  "${switchToNewServer}"
              )
          has_switched = True
          node.succeed(
              f"/run/current-system/specialisation/{name}/bin/switch-to-configuration test"
          )


      # Ensures the issuer of our cert matches the chain
      # and matches the issuer we expect it to be.
      # It's a good validation to ensure the cert.pem and fullchain.pem
      # are not still selfsigned afer verification
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
                  print(f"First subject in fullchain.pem: ", line)
                  assert cert_name.lower() in line
                  return

          assert False


      def check_connection(node, domain, retries=3):
          assert retries >= 0, f"Failed to connect to https://{domain}"

          result = node.succeed(
              "openssl s_client -brief -verify 2 -CAfile /tmp/ca.crt"
              f" -servername {domain} -connect {domain}:443 < /dev/null 2>&1"
          )

          for line in result.lower().split("\n"):
              if "verification" in line and "error" in line:
                  time.sleep(3)
                  return check_connection(node, domain, retries - 1)


      def check_connection_key_bits(node, domain, bits, retries=3):
          assert retries >= 0, f"Did not find expected number of bits ({bits}) in key"

          result = node.succeed(
              "openssl s_client -CAfile /tmp/ca.crt"
              f" -servername {domain} -connect {domain}:443 < /dev/null"
              " | openssl x509 -noout -text | grep -i Public-Key"
          )
          print("Key type:", result)

          if bits not in result:
              time.sleep(3)
              return check_connection_key_bits(node, domain, bits, retries - 1)


      def check_stapling(node, domain, retries=3):
          assert retries >= 0, "OCSP Stapling check failed"

          # Pebble doesn't provide a full OCSP responder, so just check the URL
          result = node.succeed(
              "openssl s_client -CAfile /tmp/ca.crt"
              f" -servername {domain} -connect {domain}:443 < /dev/null"
              " | openssl x509 -noout -ocsp_uri"
          )
          print("OCSP Responder URL:", result)

          if "${caDomain}:4002" not in result.lower():
              time.sleep(3)
              return check_stapling(node, domain, retries - 1)


      def download_ca_certs(node, retries=5):
          assert retries >= 0, "Failed to connect to pebble to download root CA certs"

          exit_code, _ = node.execute("curl https://${caDomain}:15000/roots/0 > /tmp/ca.crt")
          exit_code_2, _ = node.execute(
              "curl https://${caDomain}:15000/intermediate-keys/0 >> /tmp/ca.crt"
          )

          if exit_code + exit_code_2 > 0:
              time.sleep(3)
              return download_ca_certs(node, retries - 1)


      client.start()
      dnsserver.start()

      dnsserver.wait_for_unit("pebble-challtestsrv.service")
      client.wait_for_unit("default.target")

      client.succeed(
          'curl --data \'{"host": "${caDomain}", "addresses": ["${nodes.acme.config.networking.primaryIPAddress}"]}\' http://${dnsServerIP nodes}:8055/add-a'
      )

      acme.start()
      webserver.start()

      acme.wait_for_unit("network-online.target")
      acme.wait_for_unit("pebble.service")

      download_ca_certs(client)

      with subtest("Can request certificate with HTTPS-01 challenge"):
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_fullchain(webserver, "a.example.test")
          check_issuer(webserver, "a.example.test", "pebble")
          check_connection(client, "a.example.test")

      with subtest("Certificates and accounts have safe + valid permissions"):
          group = "${nodes.webserver.config.security.acme.certs."a.example.test".group}"
          webserver.succeed(
              f"test $(stat -L -c \"%a %U %G\" /var/lib/acme/a.example.test/* | tee /dev/stderr | grep '640 acme {group}' | wc -l) -eq 5"
          )
          webserver.succeed(
              f"test $(stat -L -c \"%a %U %G\" /var/lib/acme/.lego/a.example.test/**/* | tee /dev/stderr | grep '640 acme {group}' | wc -l) -eq 5"
          )
          webserver.succeed(
              f"test $(stat -L -c \"%a %U %G\" /var/lib/acme/a.example.test | tee /dev/stderr | grep '750 acme {group}' | wc -l) -eq 1"
          )
          webserver.succeed(
              f"test $(find /var/lib/acme/accounts -type f -exec stat -L -c \"%a %U %G\" {{}} \\; | tee /dev/stderr | grep -v '600 acme {group}' | wc -l) -eq 0"
          )

      with subtest("Can generate valid selfsigned certs"):
          webserver.succeed("systemctl clean acme-a.example.test.service --what=state")
          webserver.succeed("systemctl start acme-selfsigned-a.example.test.service")
          check_fullchain(webserver, "a.example.test")
          check_issuer(webserver, "a.example.test", "minica")
          # Will succeed if nginx can load the certs
          webserver.succeed("systemctl start nginx-config-reload.service")

      with subtest("Can reload nginx when timer triggers renewal"):
          webserver.succeed("systemctl start test-renew-nginx.target")
          check_issuer(webserver, "a.example.test", "pebble")
          check_connection(client, "a.example.test")

      with subtest("Runs 1 cert for account creation before others"):
          switch_to(webserver, "account-creation")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_connection(client, "a.example.test")
          webserver.wait_for_unit("acme-finished-b.example.test.target")
          webserver.wait_for_unit("acme-finished-c.example.test.target")
          check_connection(client, "b.example.test")
          check_connection(client, "c.example.test")

      with subtest("Can reload web server when cert configuration changes"):
          switch_to(webserver, "cert-change")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_connection_key_bits(client, "a.example.test", "384")
          webserver.succeed("grep testing /var/lib/acme/a.example.test/test")

      with subtest("Correctly implements OCSP stapling"):
          switch_to(webserver, "ocsp-stapling")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_stapling(client, "a.example.test")

      with subtest("Can request certificate with HTTPS-01 when nginx startup is delayed"):
          switch_to(webserver, "slow-startup")
          webserver.wait_for_unit("acme-finished-slow.example.com.target")
          check_issuer(webserver, "slow.example.com", "pebble")
          check_connection(client, "slow.example.com")

      with subtest("Can request certificate for vhost + aliases (nginx)"):
          # Check the key hash before and after adding an alias. It should not change.
          # The previous test reverts the ed384 change
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          keyhash_old = webserver.succeed("md5sum /var/lib/acme/a.example.test/key.pem")
          switch_to(webserver, "nginx-aliases")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          check_issuer(webserver, "a.example.test", "pebble")
          check_connection(client, "a.example.test")
          check_connection(client, "b.example.test")
          keyhash_new = webserver.succeed("md5sum /var/lib/acme/a.example.test/key.pem")
          assert keyhash_old == keyhash_new

      with subtest("Can request certificates for vhost + aliases (apache-httpd)"):
          try:
              switch_to(webserver, "httpd-aliases")
              webserver.wait_for_unit("acme-finished-c.example.test.target")
          except Exception as err:
              _, output = webserver.execute(
                  "cat /var/log/httpd/*.log && ls -al /var/lib/acme/acme-challenge"
              )
              print(output)
              raise err
          check_issuer(webserver, "c.example.test", "pebble")
          check_connection(client, "c.example.test")
          check_connection(client, "d.example.test")

      with subtest("Can reload httpd when timer triggers renewal"):
          # Switch to selfsigned first
          webserver.succeed("systemctl clean acme-c.example.test.service --what=state")
          webserver.succeed("systemctl start acme-selfsigned-c.example.test.service")
          check_issuer(webserver, "c.example.test", "minica")
          webserver.succeed("systemctl start httpd-config-reload.service")
          webserver.succeed("systemctl start test-renew-httpd.target")
          check_issuer(webserver, "c.example.test", "pebble")
          check_connection(client, "c.example.test")

      with subtest("Can request wildcard certificates using DNS-01 challenge"):
          switch_to(webserver, "dns-01")
          webserver.wait_for_unit("acme-finished-example.test.target")
          check_issuer(webserver, "example.test", "pebble")
          check_connection(client, "dns.example.test")
    '';
})
