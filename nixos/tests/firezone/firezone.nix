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

          provision = {
            enable = true;
            accounts.main = {
              name = "My Account";
              relayGroups.my-relays.name = "Relays";
              gatewayGroups.site.name = "Site";
              actors = {
                admin = {
                  type = "account_admin_user";
                  name = "Admin";
                  email = "admin@localhost.localdomain";
                };
                client = {
                  type = "service_account";
                  name = "A client";
                  email = "client@example.com";
                };
              };
              # service accounts aren't members of 'Everyone' so we need to add a separate group
              groups.main = {
                name = "main";
                members = [
                  "client"
                  "admin"
                ];
              };
              resources.res1 = {
                type = "dns";
                name = "Dns Resource";
                address = "resource.example.com";
                gatewayGroups = [ "site" ];
                filters = [
                  { protocol = "icmp"; }
                  {
                    protocol = "tcp";
                    ports = [ 80 ];
                  }
                ];
              };
              resources.res2 = {
                type = "ip";
                name = "Ip Resource";
                address = "172.20.2.1";
                gatewayGroups = [ "site" ];
              };
              resources.res3 = {
                type = "cidr";
                name = "Cidr Resource";
                address = "172.20.1.0/24";
                gatewayGroups = [ "site" ];
              };
              policies.pol1 = {
                description = "Allow anyone res1 access";
                group = "main";
                resource = "res1";
              };
              policies.pol2 = {
                description = "Allow anyone res2 access";
                group = "main";
                resource = "res2";
              };
              policies.pol3 = {
                description = "Allow anyone res3 access";
                group = "main";
                resource = "res3";
              };
            };
          };

          api.externalUrl = "https://${domain}/api/";
          web.externalUrl = "https://${domain}/";
        };

        systemd.services.firezone-server-domain.postStart = lib.mkAfter ''
          ${lib.getExe config.services.firezone.server.domain.package} rpc 'Code.eval_file("${./create-tokens.exs}")'
        '';
      };

    relay =
      {
        nodes,
        config,
        lib,
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
          tokenFile = "/tmp/shared/relay_token.txt";
          publicIpv4 = config.networking.primaryIPAddress;
          publicIpv6 = config.networking.primaryIPv6Address;
          openFirewall = true;
        };

        # Don't auto-start so we can wait until the token was provisioned
        systemd.services.firezone-relay.wantedBy = lib.mkForce [ ];
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
          tokenFile = "/tmp/shared/gateway_token.txt";
        };

        # Don't auto-start so we can wait until the token was provisioned
        systemd.services.firezone-gateway.wantedBy = lib.mkForce [ ];
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
          tokenFile = "/tmp/shared/client_token.txt";
        };

        # Don't auto-start so we can wait until the token was provisioned
        systemd.services.firezone-headless-client.wantedBy = lib.mkForce [ ];
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

          # Wait for tokens and copy them to shared folder
          server.wait_for_file("/var/lib/private/firezone/relay_token.txt")
          server.wait_for_file("/var/lib/private/firezone/gateway_token.txt")
          server.wait_for_file("/var/lib/private/firezone/client_token.txt")
          server.succeed("cp /var/lib/private/firezone/*_token.txt /tmp/shared")

      with subtest("Connect relay"):
          relay.succeed("systemctl start firezone-relay")
          relay.wait_for_unit("firezone-relay.service")
          relay.wait_until_succeeds("journalctl --since -2m --unit firezone-relay.service --grep 'Connected to portal.*${domain}'", timeout=30)

      with subtest("Connect gateway"):
          gateway.succeed("systemctl start firezone-gateway")
          gateway.wait_for_unit("firezone-gateway.service")
          gateway.wait_until_succeeds("journalctl --since -2m --unit firezone-gateway.service --grep 'Connected to portal.*${domain}'", timeout=30)
          relay.wait_until_succeeds("journalctl --since -2m --unit firezone-relay.service --grep 'Created allocation.*IPv4'", timeout=30)
          relay.wait_until_succeeds("journalctl --since -2m --unit firezone-relay.service --grep 'Created allocation.*IPv6'", timeout=30)

          # Assert both relay ips are known
          gateway.wait_until_succeeds("journalctl --since -2m --unit firezone-gateway.service --grep 'Updated allocation.*relay_ip4.*Some.*relay_ip6.*Some'", timeout=30)

      with subtest("Connect headless-client"):
          client.succeed("systemctl start firezone-headless-client")
          client.wait_for_unit("firezone-headless-client.service")
          client.wait_until_succeeds("journalctl --since -2m --unit firezone-headless-client.service --grep 'Connected to portal.*${domain}'", timeout=30)
          client.wait_until_succeeds("journalctl --since -2m --unit firezone-headless-client.service --grep 'Tunnel ready'", timeout=30)

      with subtest("Check DNS based access"):
          # Check that we can access the resource through the VPN via DNS
          client.wait_until_succeeds("curl -4 -Lsf http://resource.example.com | grep 'greetings from the resource'")

      with subtest("Check CIDR based access"):
          # Check that we can access the resource through the VPN via CIDR
          client.wait_until_succeeds("ping -c1 -W1 172.20.1.1")

      with subtest("Check IP based access"):
          # Check that we can access the resource through the VPN via IP
          client.wait_until_succeeds("ping -c1 -W1 172.20.2.1")
    '';
}
