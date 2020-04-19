let
  commonConfig = ./common/acme/client;

  dnsScript = {writeScript, dnsAddress, bash, curl}: writeScript "dns-hook.sh" ''
    #!${bash}/bin/bash
    set -euo pipefail
    echo '[INFO]' "[$2]" 'dns-hook.sh' $*
    if [ "$1" = "present" ]; then
      ${curl}/bin/curl --data '{"host": "'"$2"'", "value": "'"$3"'"}' http://${dnsAddress}:8055/set-txt
    else
      ${curl}/bin/curl --data '{"host": "'"$2"'"}' http://${dnsAddress}:8055/clear-txt
    fi
  '';

in import ./make-test-python.nix {
  name = "acme";

  nodes = rec {
    acme = { nodes, lib, ... }: {
      imports = [ ./common/acme/server ];
      networking.nameservers = lib.mkForce [
        nodes.dnsserver.config.networking.primaryIPAddress
      ];
    };

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

    acmeStandalone = { nodes, lib, config, pkgs, ... }: {
      imports = [ commonConfig ];
      networking.nameservers = lib.mkForce [
        nodes.dnsserver.config.networking.primaryIPAddress
      ];
      networking.firewall.allowedTCPPorts = [ 80 ];
      security.acme.certs."standalone.test" = {
        webroot = "/var/lib/acme/acme-challenges";
      };
      systemd.targets."acme-finished-standalone.test" = {};
      systemd.services."acme-standalone.test" = {
        wants = [ "acme-finished-standalone.test.target" ];
        before = [ "acme-finished-standalone.test.target" ];
      };
      services.nginx.enable = true;
      services.nginx.virtualHosts."standalone.test" = {
        locations."/.well-known/acme-challenge".root = "/var/lib/acme/acme-challenges";
      };
    };

    webserver = { nodes, config, pkgs, lib, ... }: {
      imports = [ commonConfig ];
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      networking.nameservers = lib.mkForce [
        nodes.dnsserver.config.networking.primaryIPAddress
      ];

      # A target remains active. Use this to probe the fact that
      # a service fired eventhough it is not RemainAfterExit
      systemd.targets."acme-finished-a.example.test" = {};
      systemd.services."acme-a.example.test" = {
        wants = [ "acme-finished-a.example.test.target" ];
        before = [ "acme-finished-a.example.test.target" ];
        after = [ "nginx.service" ];
      };

      services.nginx.enable = true;

      services.nginx.virtualHosts."a.example.test" = {
        enableACME = true;
        forceSSL = true;
        locations."/".root = pkgs.runCommand "docroot" {} ''
          mkdir -p "$out"
          echo hello world > "$out/index.html"
        '';
      };

      security.acme.server = "https://acme.test/dir";

      specialisation.second-cert.configuration = {pkgs, ...}: {
        systemd.targets."acme-finished-b.example.test" = {};
        systemd.services."acme-b.example.test" = {
          wants = [ "acme-finished-b.example.test.target" ];
          before = [ "acme-finished-b.example.test.target" ];
          after = [ "nginx.service" ];
        };
        services.nginx.virtualHosts."b.example.test" = {
          enableACME = true;
          forceSSL = true;
          locations."/".root = pkgs.runCommand "docroot" {} ''
            mkdir -p "$out"
            echo hello world > "$out/index.html"
          '';
        };
      };
      specialisation.dns-01.configuration = {pkgs, config, nodes, lib, ...}: {
        security.acme.certs."example.test" = {
          domain = "*.example.test";
          dnsProvider = "exec";
          dnsPropagationCheck = false;
          credentialsFile = with pkgs; writeText "wildcard.env" ''
            EXEC_PATH=${dnsScript { inherit writeScript bash curl; dnsAddress = nodes.dnsserver.config.networking.primaryIPAddress; }}
          '';
          user = config.services.nginx.user;
          group = config.services.nginx.group;
        };
        systemd.targets."acme-finished-example.test" = {};
        systemd.services."acme-example.test" = {
          wants = [ "acme-finished-example.test.target" ];
          before = [ "acme-finished-example.test.target" "nginx.service" ];
          wantedBy = [ "nginx.service" ];
        };
        services.nginx.virtualHosts."c.example.test" = {
          forceSSL = true;
          sslCertificate = config.security.acme.certs."example.test".directory + "/cert.pem";
          sslTrustedCertificate = config.security.acme.certs."example.test".directory + "/full.pem";
          sslCertificateKey = config.security.acme.certs."example.test".directory + "/key.pem";
          locations."/".root = pkgs.runCommand "docroot" {} ''
            mkdir -p "$out"
            echo hello world > "$out/index.html"
          '';
        };
      };
    };

    client = {nodes, lib, ...}: {
      imports = [ commonConfig ];
      networking.nameservers = lib.mkForce [
        nodes.dnsserver.config.networking.primaryIPAddress
      ];
    };
  };

  testScript = {nodes, ...}:
    let
      newServerSystem = nodes.webserver.config.system.build.toplevel;
      switchToNewServer = "${newServerSystem}/bin/switch-to-configuration test";
    in
    # Note, wait_for_unit does not work for oneshot services that do not have RemainAfterExit=true,
    # this is because a oneshot goes from inactive => activating => inactive, and never
    # reaches the active state. To work around this, we create some mock target units which
    # get pulled in by the oneshot units. The target units linger after activation, and hence we
    # can use them to probe that a oneshot fired. It is a bit ugly, but it is the best we can do
    ''
      client.start()
      dnsserver.start()

      acme.wait_for_unit("default.target")
      dnsserver.wait_for_unit("pebble-challtestsrv.service")
      client.succeed(
          'curl --data \'{"host": "acme.test", "addresses": ["${nodes.acme.config.networking.primaryIPAddress}"]}\' http://${nodes.dnsserver.config.networking.primaryIPAddress}:8055/add-a'
      )
      client.succeed(
          'curl --data \'{"host": "standalone.test", "addresses": ["${nodes.acmeStandalone.config.networking.primaryIPAddress}"]}\' http://${nodes.dnsserver.config.networking.primaryIPAddress}:8055/add-a'
      )

      acme.start()
      acmeStandalone.start()

      acme.wait_for_unit("default.target")
      acme.wait_for_unit("pebble.service")

      with subtest("can request certificate with HTTPS-01 challenge"):
          acmeStandalone.wait_for_unit("default.target")
          acmeStandalone.succeed("systemctl start acme-standalone.test.service")
          acmeStandalone.wait_for_unit("acme-finished-standalone.test.target")

      client.wait_for_unit("default.target")

      client.succeed("curl https://acme.test:15000/roots/0 > /tmp/ca.crt")
      client.succeed("curl https://acme.test:15000/intermediate-keys/0 >> /tmp/ca.crt")

      with subtest("Can request certificate for nginx service"):
          webserver.wait_for_unit("acme-finished-a.example.test.target")
          client.succeed(
              "curl --cacert /tmp/ca.crt https://a.example.test/ | grep -qF 'hello world'"
          )

      with subtest("Can add another certificate for nginx service"):
          webserver.succeed(
              "/run/current-system/specialisation/second-cert/bin/switch-to-configuration test"
          )
          webserver.wait_for_unit("acme-finished-b.example.test.target")
          client.succeed(
              "curl --cacert /tmp/ca.crt https://b.example.test/ | grep -qF 'hello world'"
          )

      with subtest("Can request wildcard certificates using DNS-01 challenge"):
          webserver.succeed(
              "${switchToNewServer}"
          )
          webserver.succeed(
              "/run/current-system/specialisation/dns-01/bin/switch-to-configuration test"
          )
          webserver.wait_for_unit("acme-finished-example.test.target")
          client.succeed(
              "curl --cacert /tmp/ca.crt https://c.example.test/ | grep -qF 'hello world'"
          )
    '';
}
