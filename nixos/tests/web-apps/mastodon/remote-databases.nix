import ../../make-test-python.nix (
  { pkgs, ... }:
  let
    cert =
      pkgs:
      pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
        openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=mastodon.local' -days 36500
        mkdir -p $out
        cp key.pem cert.pem $out
      '';

    hosts = ''
      192.168.2.103 mastodon.local
    '';

    postgresqlPassword = "thisisnotasecret";
    redisPassword = "thisisnotasecrettoo";

  in
  {
    name = "mastodon-remote-postgresql";
    meta.maintainers = with pkgs.lib.maintainers; [
      erictapen
      izorkin
    ];

    nodes = {
      databases =
        { config, ... }:
        {
          environment = {
            etc = {
              "redis/password-redis-db".text = redisPassword;
            };
          };
          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.102";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = hosts;
            firewall.allowedTCPPorts = [
              config.services.redis.servers.mastodon.port
              config.services.postgresql.settings.port
            ];
          };

          services.redis.servers.mastodon = {
            enable = true;
            bind = "0.0.0.0";
            port = 31637;
            requirePassFile = "/etc/redis/password-redis-db";
          };

          services.postgresql = {
            enable = true;
            enableTCPIP = true;
            authentication = ''
              hostnossl mastodon mastodon 192.168.2.201/32 md5
            '';
            ensureDatabases = [ "mastodon" ];
            ensureUsers = [
              {
                name = "mastodon";
                ensureDBOwnership = true;
              }
            ];
            initialScript = pkgs.writeText "postgresql_init.sql" ''
              CREATE ROLE mastodon LOGIN PASSWORD '${postgresqlPassword}';
            '';
          };
        };

      nginx =
        { nodes, ... }:
        {
          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.103";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = hosts;
            firewall.allowedTCPPorts = [
              80
              443
            ];
          };

          security = {
            pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
          };

          services.nginx = {
            enable = true;
            recommendedProxySettings = true;
            virtualHosts."mastodon.local" = {
              root = "/var/empty";
              forceSSL = true;
              enableACME = pkgs.lib.mkForce false;
              sslCertificate = "${cert pkgs}/cert.pem";
              sslCertificateKey = "${cert pkgs}/key.pem";
              locations."/" = {
                tryFiles = "$uri @proxy";
              };
              locations."@proxy" = {
                proxyPass = "http://192.168.2.201:${toString nodes.server.services.mastodon.webPort}";
                proxyWebsockets = true;
              };
            };
          };
        };

      server =
        { config, pkgs, ... }:
        {
          virtualisation.memorySize = 2048;

          environment = {
            etc = {
              "mastodon/password-redis-db".text = redisPassword;
              "mastodon/password-posgressql-db".text = postgresqlPassword;
            };
          };

          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.201";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = hosts;
            firewall.allowedTCPPorts = [
              config.services.mastodon.webPort
              config.services.mastodon.sidekiqPort
            ];
          };

          services.mastodon = {
            enable = true;
            configureNginx = false;
            localDomain = "mastodon.local";
            enableUnixSocket = false;
            streamingProcesses = 2;
            redis = {
              createLocally = false;
              host = "192.168.2.102";
              port = 31637;
              passwordFile = "/etc/mastodon/password-redis-db";
            };
            database = {
              createLocally = false;
              host = "192.168.2.102";
              port = 5432;
              name = "mastodon";
              user = "mastodon";
              passwordFile = "/etc/mastodon/password-posgressql-db";
            };
            smtp = {
              createLocally = false;
              fromAddress = "mastodon@mastodon.local";
            };
            extraConfig = {
              BIND = "0.0.0.0";
              EMAIL_DOMAIN_ALLOWLIST = "example.com";
              RAILS_SERVE_STATIC_FILES = "true";
              TRUSTED_PROXY_IP = "192.168.2.103";
            };
          };
        };

      client =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.jq ];
          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.202";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = hosts;
          };

          security = {
            pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
          };
        };
    };

    testScript = import ./script.nix {
      inherit pkgs;
      extraInit = ''
        nginx.wait_for_unit("nginx.service")
        nginx.wait_for_open_port(443)
        databases.wait_for_unit("redis-mastodon.service")
        databases.wait_for_unit("postgresql.service")
        databases.wait_for_open_port(31637)
        databases.wait_for_open_port(5432)
      '';
      extraShutdown = ''
        nginx.shutdown()
        databases.shutdown()
      '';
    };
  }
)
