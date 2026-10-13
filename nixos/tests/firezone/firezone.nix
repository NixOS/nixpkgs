{ pkgs, ... }:
let
  certs = import ../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  name = "firezone";
  meta.maintainers = with pkgs.lib.maintainers; [
    oddlama
    patrickdag
  ];

  nodes = {
    server =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        security.pki.certificateFiles = [ certs.ca.cert ];

        # To debug problems:
        # 1. comment this in
        # 2. cat '127.0.0.1 acme.test` >> /etc/hosts
        # 3. socat TCP-LISTEN:443,fork TCP:127.0.0.1:12345
        # 4. Firezone has to succeed when sending mail
        #   - Get opensmtpd to work
        #   - add an actual mailaccount to the test
        # virtualisation.forwardPorts = [
        #   {
        #     from = "host";
        #     host.port = 12345;
        #     guest.port = 443;
        #   }
        # ];

        networking.extraHosts = ''
          ${config.networking.primaryIPAddress} ${domain}
          ${config.networking.primaryIPv6Address} ${domain}
        '';

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        services.nginx = {
          enable = true;
          virtualHosts.${domain} = {
            sslCertificate = certs.${domain}.cert;
            sslCertificateKey = certs.${domain}.key;
          };
        };

        # This doesn't actually work firezone/Swoosh seems to send 2 `EHLO`
        # which opensmtpd does not allow
        # https://github.com/OpenSMTPD/OpenSMTPD/issues/1284
        # Would be nice for debbuging
        # services.opensmtpd = {
        #   enable = true;
        #   extraServerArgs = [ "-v" ];
        #   serverConfiguration = ''
        #     listen on 0.0.0.0
        #     action "local" maildir "/tmp/maildir"
        #     match for domain "localhost.localdomain" action "local"
        #   '';
        # };

        services.firezone.server = {
          enable = true;
          enableLocalDB = true;
          nginx.enable = true;

          # Doesn't need to work for this test, but needs to be configured
          # otherwise the server will not start.
          smtp = {
            from = "firezone@localhost.localdomain";
            host = "localhost";
            port = 25;
            implicitTls = false;
            username = "firezone@localhost.localdomain";
            passwordFile = pkgs.writeText "tmpmailpasswd" "verysecurepassword";
          };

          api.externalUrl = "https://${domain}/api/";
          web.externalUrl = "https://${domain}/";
        };
      };

    relay =
      {
        nodes,
        config,
        ...
      }:
      {
        security.pki.certificateFiles = [ certs.ca.cert ];
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} ${domain}
          ${nodes.server.networking.primaryIPv6Address} ${domain}
        '';

        services.firezone.relay = {
          enable = true;
          logLevel = "debug";
          name = "test-relay";
          apiUrl = "wss://${domain}/api/";
          tokenFile = pkgs.writeText "token" "token";
          publicIpv4 = config.networking.primaryIPAddress;
          publicIpv6 = config.networking.primaryIPv6Address;
          openFirewall = true;
        };
      };

    # A resource that is only connected to the gateway,
    # allowing us to confirm the VPN works
    resource = {
      virtualisation.vlans = [
        1
        2
      ];

      networking.interfaces.eth1.ipv4.addresses = [
        {
          address = "172.20.1.1";
          prefixLength = 24;
        }
      ];

      networking.interfaces.eth2.ipv4.addresses = [
        {
          address = "172.20.2.1";
          prefixLength = 24;
        }
      ];

      networking.firewall.allowedTCPPorts = [
        80
      ];

      services.nginx = {
        enable = true;
        virtualHosts = {
          "localhost" = {
            default = true;
            locations."/".extraConfig = ''
              return 200 'greetings from the resource';
              add_header Content-Type text/plain;
            '';
          };
        };
      };
    };

    gateway =
      {
        nodes,
        lib,
        ...
      }:
      {
        virtualisation.vlans = [
          1
          2
        ];

        networking = {
          interfaces.eth1.ipv4.addresses = [
            {
              address = "172.20.1.2";
              prefixLength = 24;
            }
          ];

          interfaces.eth2.ipv4.addresses = [
            {
              address = "172.20.2.2";
              prefixLength = 24;
            }
          ];

          firewall.enable = false;
          nftables.enable = true;
          nftables.tables."filter".family = "inet";
          nftables.tables."filter".content = ''
            chain incoming {
              type filter hook input priority 0; policy accept;
            }

            chain postrouting {
              type nat hook postrouting priority srcnat; policy accept;
              meta protocol ip iifname "tun-firezone" oifname { "eth1", "eth2" } masquerade random
            }

            chain forward {
              type filter hook forward priority 0; policy drop;
              iifname "tun-firezone" accept
              oifname "tun-firezone" accept
            }

            chain output {
              type filter hook output priority 0; policy accept;
            }
          '';
        };

        boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
        # boot.kernel.sysctl."net.ipv4.conf.all.src_valid_mark" = "1";
        boot.kernel.sysctl."net.ipv6.conf.default.forwarding" = "1";
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";

        security.pki.certificateFiles = [ certs.ca.cert ];
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} ${domain}
          ${nodes.server.networking.primaryIPv6Address} ${domain}
          172.20.1.1 resource.example.com
        '';

        services.firezone.gateway = {
          enable = true;
          logLevel = "debug";
          name = "test-gateway";
          apiUrl = "wss://${domain}/api/";
          tokenFile = pkgs.writeText "token" "token";
        };
      };

    client =
      {
        nodes,
        lib,
        ...
      }:
      {
        security.pki.certificateFiles = [ certs.ca.cert ];
        networking.useNetworkd = true;
        networking.extraHosts = ''
          ${nodes.server.networking.primaryIPAddress} ${domain}
          ${nodes.server.networking.primaryIPv6Address} ${domain}
        '';

        services.firezone.headless-client = {
          enable = true;
          logLevel = "debug";
          name = "test-client-somebody";
          apiUrl = "wss://${domain}/api/";
          tokenFile = pkgs.writeText "token" "token";
        };
      };
  };

  testScript =
    { ... }:
    ''
      start_all()

      with subtest("Start server"):
          server.wait_for_unit("firezone.target")
          server.wait_until_succeeds("curl -Lsf https://${domain} | grep 'Welcome to Firezone'")
          server.wait_until_succeeds("curl -Ls https://${domain}/api | grep 'Not Found'")

      with subtest("Connect relay"):
          relay.wait_for_unit("firezone-relay.service")

      with subtest("Connect gateway"):
          gateway.wait_for_unit("firezone-gateway.service")

      with subtest("Connect headless-client"):
          client.wait_for_unit("firezone-headless-client.service")
    '';
}
