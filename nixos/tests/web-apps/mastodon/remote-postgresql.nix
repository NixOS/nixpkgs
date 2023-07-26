import ../../make-test-python.nix ({pkgs, ...}:
let
  cert = pkgs: pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=mastodon.local' -days 36500
    mkdir -p $out
    cp key.pem cert.pem $out
  '';

  hosts = ''
    192.168.2.103 mastodon.local
  '';

in
{
  name = "mastodon-remote-postgresql";
  meta.maintainers = with pkgs.lib.maintainers; [ erictapen izorkin ];

  nodes = {
    database = {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.102"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
        firewall.allowedTCPPorts = [ 5432 ];
      };

      services.postgresql = {
        enable = true;
        enableTCPIP = true;
        authentication = ''
          hostnossl mastodon_local mastodon_test 192.168.2.201/32 md5
        '';
        initialScript = pkgs.writeText "postgresql_init.sql" ''
          CREATE ROLE mastodon_test LOGIN PASSWORD 'SoDTZcISc3f1M1LJsRLT';
          CREATE DATABASE mastodon_local TEMPLATE template0 ENCODING UTF8;
          GRANT ALL PRIVILEGES ON DATABASE mastodon_local TO mastodon_test;
        '';
      };
    };

    nginx = {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.103"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
        firewall.allowedTCPPorts = [ 80 443 ];
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
            proxyPass = "http://192.168.2.201:55001";
            proxyWebsockets = true;
          };
          locations."/api/v1/streaming/" = {
            proxyPass = "http://192.168.2.201:55002";
            proxyWebsockets = true;
          };
        };
      };
    };

    server = { pkgs, ... }: {
      virtualisation.memorySize = 2048;

      environment = {
        etc = {
          "mastodon/password-posgressql-db".text = ''
            SoDTZcISc3f1M1LJsRLT
          '';
        };
      };

      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.201"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
        firewall.allowedTCPPorts = [ 55001 55002 ];
      };

      services.mastodon = {
        enable = true;
        configureNginx = false;
        localDomain = "mastodon.local";
        enableUnixSocket = false;
        database = {
          createLocally = false;
          host = "192.168.2.102";
          port = 5432;
          name = "mastodon_local";
          user = "mastodon_test";
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

    client = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.202"; prefixLength = 24; }
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
      database.wait_for_unit("postgresql.service")
      database.wait_for_open_port(5432)
    '';
    extraShutdown = ''
      nginx.shutdown()
      database.shutdown()
    '';
  };
})
