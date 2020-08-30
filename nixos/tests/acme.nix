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

      # Cert config changes will not cause the nginx configuration to change.
      # This tests that the reload service is correctly triggered.
      specialisation.cert-change.configuration = { pkgs, ... }: {
        security.acme.certs."a.example.test".keyType = "ec384";
      };

      # Now adding an alias to ensure that the certs are updated
      specialisation.nginx-aliases.configuration = { pkgs, ... }: {
        services.nginx.virtualHosts."a.example.test" = {
          serverAliases = [ "b.example.test" ];
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
      newServerSystem = nodes.webserver.config.system.build.toplevel;
      switchToNewServer = "${newServerSystem}/bin/switch-to-configuration test";
    in
    # Note, wait_for_unit does not work for oneshot services that do not have RemainAfterExit=true,
    # this is because a oneshot goes from inactive => activating => inactive, and never
    # reaches the active state. Targets do not have this issue.

    ''
      has_switched = False


      def switch_to(node, name):
          global has_switched
          if has_switched:
              node.succeed(
                  "${switchToNewServer}"
              )
          has_switched = True
          node.succeed(
              "/run/current-system/specialisation/{}/bin/switch-to-configuration test".format(
                  name
              )
          )


      # In order to determine if a config reload has finished, we need to watch
      # the log files for the relevant lines
      def wait_httpd_reload(node):
          # Check for SIGUSER received
          node.succeed("( tail -n3 -f /var/log/httpd/error.log & ) | grep -q AH00493")
          # Check for service restart. This line also occurs when the service is started,
          # hence the above check is necessary too.
          node.succeed("( tail -n1 -f /var/log/httpd/error.log & ) | grep -q AH00094")


      def wait_nginx_reload(node):
          # Check for SIGHUP received
          node.succeed("( journalctl -fu nginx -n18 & ) | grep -q SIGHUP")
          # Check for SIGCHLD from killed worker processes
          node.succeed("( journalctl -fu nginx -n10 & ) | grep -q SIGCHLD")


      # Ensures the issuer of our cert matches the chain
      # and matches the issuer we expect it to be.
      # It's a good validation to ensure the cert.pem and fullchain.pem
      # are not still selfsigned afer verification
      def check_issuer(node, cert_name, issuer):
          for fname in ("cert.pem", "fullchain.pem"):
              node.succeed(
                  (
                      """openssl x509 -noout -issuer -in /var/lib/acme/{cert_name}/{fname} \
                        | tee /proc/self/fd/2 \
                        | cut -d'=' -f2- \
                        | grep "$(openssl x509 -noout -subject -in /var/lib/acme/{cert_name}/chain.pem \
                        | cut -d'=' -f2-)\" \
                        | grep -i '{issuer}'
                      """
                  ).format(cert_name=cert_name, issuer=issuer, fname=fname)
              )


      # Ensure cert comes before chain in fullchain.pem
      def check_fullchain(node, cert_name):
          node.succeed(
              (
                  """openssl crl2pkcs7 -nocrl -certfile /var/lib/acme/{cert_name}/fullchain.pem \
                    | tee /proc/self/fd/2 \
                    | openssl pkcs7 -print_certs -noout | head -1 | grep {cert_name}
                  """
              ).format(cert_name=cert_name)
          )


      def check_connection(node, domain):
          node.succeed(
              (
                  """openssl s_client -brief -verify 2 -verify_return_error -CAfile /tmp/ca.crt \
                    -servername {domain} -connect {domain}:443 < /dev/null 2>&1 \
                    | tee /proc/self/fd/2
                  """
              ).format(domain=domain)
          )


      client.start()
      dnsserver.start()

      dnsserver.wait_for_unit("pebble-challtestsrv.service")
      client.wait_for_unit("default.target")

      client.succeed(
          'curl --data \'{"host": "acme.test", "addresses": ["${nodes.acme.config.networking.primaryIPAddress}"]}\' http://${dnsServerIP nodes}:8055/add-a'
      )

      acme.start()
      webserver.start()

      acme.wait_for_unit("default.target")
      acme.wait_for_unit("pebble.service")

      client.succeed("curl https://acme.test:15000/roots/0 > /tmp/ca.crt")
      client.succeed("curl https://acme.test:15000/intermediate-keys/0 >> /tmp/ca.crt")

      with subtest("Can request certificate with HTTPS-01 challenge"):
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          wait_nginx_reload(webserver)
          check_fullchain(webserver, "a.example.test")
          check_issuer(webserver, "a.example.test", "pebble")
          check_connection(client, "a.example.test")

      with subtest("Can generate valid selfsigned certs"):
          webserver.succeed("systemctl clean acme-a.example.test.service --what=state")
          webserver.succeed("systemctl start acme-selfsigned-a.example.test.service")
          check_fullchain(webserver, "a.example.test")
          check_issuer(webserver, "a.example.test", "minica")
          # Will succeed if nginx can load the certs
          webserver.succeed("systemctl start nginx-config-reload.service")
          wait_nginx_reload(webserver)

      with subtest("Can reload nginx when timer triggers renewal"):
          webserver.succeed("systemctl start test-renew-nginx.target")
          wait_nginx_reload(webserver)
          check_issuer(webserver, "a.example.test", "pebble")
          check_connection(client, "a.example.test")

      with subtest("Can reload web server when cert configuration changes"):
          switch_to(webserver, "cert-change")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          wait_nginx_reload(webserver)
          client.succeed(
              """openssl s_client -CAfile /tmp/ca.crt -connect a.example.test:443 < /dev/null \
                | openssl x509 -noout -text | grep -i Public-Key | grep 384
          """
          )

      with subtest("Can request certificate with HTTPS-01 when nginx startup is delayed"):
          switch_to(webserver, "slow-startup")
          webserver.wait_for_unit("acme-finished-slow.example.com.target")
          wait_nginx_reload(webserver)
          check_issuer(webserver, "slow.example.com", "pebble")
          check_connection(client, "slow.example.com")

      with subtest("Can request certificate for vhost + aliases (nginx)"):
          switch_to(webserver, "nginx-aliases")
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          wait_nginx_reload(webserver)
          check_issuer(webserver, "a.example.test", "pebble")
          check_connection(client, "a.example.test")
          check_connection(client, "b.example.test")

      with subtest("Can request certificates for vhost + aliases (apache-httpd)"):
          switch_to(webserver, "httpd-aliases")
          webserver.wait_for_unit("acme-finished-c.example.test.target")
          wait_httpd_reload(webserver)
          check_issuer(webserver, "c.example.test", "pebble")
          check_connection(client, "c.example.test")
          check_connection(client, "d.example.test")

      with subtest("Can reload httpd when timer triggers renewal"):
          # Switch to selfsigned first
          webserver.succeed("systemctl clean acme-c.example.test.service --what=state")
          webserver.succeed("systemctl start acme-selfsigned-c.example.test.service")
          wait_httpd_reload(webserver)
          check_issuer(webserver, "c.example.test", "minica")
          webserver.succeed("systemctl start httpd-config-reload.service")
          webserver.succeed("systemctl start test-renew-httpd.target")
          wait_httpd_reload(webserver)
          check_issuer(webserver, "c.example.test", "pebble")
          check_connection(client, "c.example.test")

      with subtest("Can request wildcard certificates using DNS-01 challenge"):
          switch_to(webserver, "dns-01")
          webserver.wait_for_unit("acme-finished-example.test.target")
          wait_nginx_reload(webserver)
          check_issuer(webserver, "example.test", "pebble")
          check_connection(client, "dns.example.test")
    '';
})
