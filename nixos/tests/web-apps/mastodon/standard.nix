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
      192.168.2.101 mastodon.local
    '';

  in
  {
    name = "mastodon-standard";
    meta.maintainers = with pkgs.lib.maintainers; [
      erictapen
      izorkin
      turion
    ];

    nodes = {
      server =
        { pkgs, ... }:
        {

          virtualisation.memorySize = 2048;

          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.101";
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

          # TODO remove once https://github.com/NixOS/nixpkgs/pull/266270 is resolved.
          services.postgresql.package = pkgs.postgresql_14;

          services.mastodon = {
            enable = true;
            configureNginx = true;
            localDomain = "mastodon.local";
            enableUnixSocket = false;
            streamingProcesses = 2;
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

      client =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.jq ];
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
          };

          security = {
            pki.certificateFiles = [ "${cert pkgs}/cert.pem" ];
          };
        };
    };

    testScript = import ./script.nix {
      inherit pkgs;
      extraInit = ''
        server.wait_for_unit("nginx.service")
        server.wait_for_open_port(443)
        server.wait_for_unit("redis-mastodon.service")
        server.wait_for_unit("postgresql.service")
        server.wait_for_open_port(5432)
      '';
    };
  }
)
