import ../make-test-python.nix ({pkgs, ...}:
let
  test-certificates = pkgs.runCommandLocal "test-certificates" { } ''
    mkdir -p $out
    echo insecure-root-password > $out/root-password-file
    echo insecure-intermediate-password > $out/intermediate-password-file
    ${pkgs.step-cli}/bin/step certificate create "Example Root CA" $out/root_ca.crt $out/root_ca.key --password-file=$out/root-password-file --profile root-ca
    ${pkgs.step-cli}/bin/step certificate create "Example Intermediate CA 1" $out/intermediate_ca.crt $out/intermediate_ca.key --password-file=$out/intermediate-password-file --ca-password-file=$out/root-password-file --profile intermediate-ca --ca $out/root_ca.crt --ca-key $out/root_ca.key
  '';

  hosts = ''
    192.168.2.10 ca.local
    192.168.2.11 mastodon.local
  '';

in
{
  name = "mastodon";
  meta.maintainers = with pkgs.lib.maintainers; [ erictapen izorkin ];

  nodes = {
    ca = { pkgs, ... }: {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.10"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
      };
      services.step-ca = {
        enable = true;
        address = "0.0.0.0";
        port = 8443;
        openFirewall = true;
        intermediatePasswordFile = "${test-certificates}/intermediate-password-file";
        settings = {
          dnsNames = [ "ca.local" ];
          root = "${test-certificates}/root_ca.crt";
          crt = "${test-certificates}/intermediate_ca.crt";
          key = "${test-certificates}/intermediate_ca.key";
          db = {
            type = "badger";
            dataSource = "/var/lib/step-ca/db";
          };
          authority = {
            provisioners = [
              {
                type = "ACME";
                name = "acme";
              }
            ];
          };
        };
      };
    };

    server = { pkgs, ... }: {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.11"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
        firewall.allowedTCPPorts = [ 80 443 ];
      };

      security = {
        acme = {
          acceptTerms = true;
          defaults.server = "https://ca.local:8443/acme/acme/directory";
          defaults.email = "mastodon@mastodon.local";
        };
        pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];
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
        redis = {
          createLocally = true;
          host = "127.0.0.1";
          port = 31637;
        };
        database = {
          createLocally = true;
          host = "/run/postgresql";
          port = 5432;
        };
        smtp = {
          createLocally = false;
          fromAddress = "mastodon@mastodon.local";
        };
        extraConfig = {
          EMAIL_DOMAIN_ALLOWLIST = "example.com";
        };
      };
    };

    client = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.12"; prefixLength = 24; }
          ];
        };
        extraHosts = hosts;
      };

      security = {
        pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];
      };
    };
  };

  testScript = ''
    start_all()

    ca.wait_for_unit("step-ca.service")
    ca.wait_for_open_port(8443)

    server.wait_for_unit("nginx.service")
    server.wait_for_unit("redis-mastodon.service")
    server.wait_for_unit("postgresql.service")
    server.wait_for_unit("mastodon-sidekiq.service")
    server.wait_for_unit("mastodon-streaming.service")
    server.wait_for_unit("mastodon-web.service")
    server.wait_for_open_port(55000)
    server.wait_for_open_port(55001)

    # Check Mastodon version from remote client
    client.succeed("curl --fail https://mastodon.local/api/v1/instance | jq -r '.version' | grep '${pkgs.mastodon.version}'")

    # Check using admin CLI
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
    server.fail("su - mastodon -s /bin/sh -c 'mastodon-env tootctl p_blocks export' | grep '172.16.0.0/16'")
    client.fail("curl --fail https://mastodon.local/about")
    server.succeed("su - mastodon -s /bin/sh -c 'mastodon-env tootctl ip_blocks remove 192.168.0.0/16'")
    client.succeed("curl --fail https://mastodon.local/about")

    ca.shutdown()
    server.shutdown()
    client.shutdown()
  '';
})
