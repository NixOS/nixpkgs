import ./make-test-python.nix ({ pkgs, ... }:
  let
    test-certificates = pkgs.runCommandLocal "test-certificates" { } ''
      mkdir -p $out
      echo insecure-root-password > $out/root-password-file
      echo insecure-intermediate-password > $out/intermediate-password-file
      ${pkgs.step-cli}/bin/step certificate create "Example Root CA" $out/root_ca.crt $out/root_ca.key --password-file=$out/root-password-file --profile root-ca
      ${pkgs.step-cli}/bin/step certificate create "Example Intermediate CA 1" $out/intermediate_ca.crt $out/intermediate_ca.key --password-file=$out/intermediate-password-file --ca-password-file=$out/root-password-file --profile intermediate-ca --ca $out/root_ca.crt --ca-key $out/root_ca.key
    '';
  in
  {
    name = "step-ca";
    nodes =
      {
        caserver =
          { config, pkgs, ... }: {
            services.step-ca = {
              enable = true;
              address = "0.0.0.0";
              port = 8443;
              openFirewall = true;
              intermediatePasswordFile = "${test-certificates}/intermediate-password-file";
              settings = {
                dnsNames = [ "caserver" ];
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

        caclient =
          { config, pkgs, ... }: {
            security.acme.defaults.server = "https://caserver:8443/acme/acme/directory";
            security.acme.defaults.email = "root@example.org";
            security.acme.acceptTerms = true;

            security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];

            networking.firewall.allowedTCPPorts = [ 80 443 ];

            services.nginx = {
              enable = true;
              virtualHosts = {
                "caclient" = {
                  forceSSL = true;
                  enableACME = true;
                };
              };
            };
          };

        caclientcaddy =
          { config, pkgs, ... }: {
            security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];

            networking.firewall.allowedTCPPorts = [ 80 443 ];

            services.caddy = {
              enable = true;
              virtualHosts."caclientcaddy".extraConfig = ''
                respond "Welcome to Caddy!"

                tls caddy@example.org {
                  ca https://caserver:8443/acme/acme/directory
                }
              '';
            };
          };

        catester = { config, pkgs, ... }: {
          security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];
        };
      };

    testScript =
      ''
        catester.start()
        caserver.wait_for_unit("step-ca.service")
        caserver.wait_until_succeeds("journalctl -o cat -u step-ca.service | grep '${pkgs.step-ca.version}'")

        caclient.wait_for_unit("acme-finished-caclient.target")
        catester.succeed("curl https://caclient/ | grep \"Welcome to nginx!\"")

        caclientcaddy.wait_for_unit("caddy.service")
        catester.succeed("curl https://caclientcaddy/ | grep \"Welcome to Caddy!\"")
      '';
  })
