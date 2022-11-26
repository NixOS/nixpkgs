import ../make-test-python.nix ({pkgs, ...}:
let
  cert = pkgs: pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=mastodon.local' -days 36500
    mkdir -p $out
    cp key.pem cert.pem $out
  '';

  hosts = ''
    192.168.2.101 mastodon.local
  '';

in
{
  name = "mastodon";
  meta.maintainers = with pkgs.lib.maintainers; [ erictapen izorkin turion ];

  nodes = {
    server = { pkgs, ... }: {

      virtualisation.memorySize = 2048;

      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.101"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
        firewall.allowedTCPPorts = [ 80 443 ];
      };

      security = {
        pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
      };

      services.redis.servers.mastodon = {
        enable = true;
        bind = "127.0.0.1";
        port = 31637;
      };

      services.mastodon = {
        enable = true;
        configureNginx = true;
        localDomain = "mastodon.local";
        enableUnixSocket = false;
        smtp = {
          createLocally = false;
          fromAddress = "mastodon@mastodon.local";
        };
        extraConfig = {
          EMAIL_DOMAIN_ALLOWLIST = "example.com";
        };
      };

      services.nginx = {
        virtualHosts."mastodon.local" = {
          enableACME = pkgs.lib.mkForce false;
          sslCertificate = "${cert pkgs}/cert.pem";
          sslCertificateKey = "${cert pkgs}/key.pem";
        };
      };
    };

    client = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.102"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
      };

      security = {
        pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
      };
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("nginx.service")
    server.wait_for_unit("redis-mastodon.service")
    server.wait_for_unit("postgresql.service")
    server.wait_for_unit("mastodon-sidekiq.service")
    server.wait_for_unit("mastodon-streaming.service")
    server.wait_for_unit("mastodon-web.service")
    server.wait_for_open_port(55000)
    server.wait_for_open_port(55001)

    # Check that mastodon-media-auto-remove is scheduled
    server.succeed("systemctl status mastodon-media-auto-remove.timer")

    # Check Mastodon version from remote client
    client.succeed("curl --fail https://mastodon.local/api/v1/instance | jq -r '.version' | grep '${pkgs.mastodon.version}'")

    # Check access from remote client
    client.succeed("curl --fail https://mastodon.local/about | grep 'Mastodon hosted on mastodon.local'")
    client.succeed("curl --fail $(curl https://mastodon.local/api/v1/instance 2> /dev/null | jq -r .thumbnail) --output /dev/null")

    # Simple check tootctl commands
    # Check Mastodon version
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl version' | grep '${pkgs.mastodon.version}'")

    # Manage accounts
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl email_domain_blocks add example.com'")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl email_domain_blocks list' | grep 'example.com'")
    server.fail("su - mastodon -s /bin/sh -c 'mastodon-env tootctl email_domain_blocks list' | grep 'mastodon.local'")
    server.fail("su - mastodon -s /bin/sh -c 'mastodon-env tootctl accounts create alice --email=alice@example.com'")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl email_domain_blocks remove example.com'")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl accounts create bob --email=bob@example.com'")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl accounts approve bob'")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl accounts delete bob'")

    # Manage IP access
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl ip_blocks add 192.168.0.0/16 --severity=no_access'")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl ip_blocks export' | grep '192.168.0.0/16'")
    server.fail("su - mastodon -s /bin/sh -c 'mastodon-env tootctl ip_blocks export' | grep '172.16.0.0/16'")
    client.fail("curl --fail https://mastodon.local/about")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl ip_blocks remove 192.168.0.0/16'")
    client.succeed("curl --fail https://mastodon.local/about")

    server.shutdown()
    client.shutdown()
  '';
})
