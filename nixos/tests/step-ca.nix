import ./make-test-python.nix (
  { pkgs, ... }:
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
    nodes = {
      caserver =
        { config, pkgs, ... }:
        {
          services.step-ca = {
            enable = true;
            address = "[::]";
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
        { config, pkgs, ... }:
        {
          security.acme.defaults.server = "https://caserver:8443/acme/acme/directory";
          security.acme.defaults.email = "root@example.org";
          security.acme.acceptTerms = true;

          security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];

          networking.firewall.allowedTCPPorts = [
            80
            443
          ];

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
        { config, pkgs, ... }:
        {
          security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];

          networking.firewall.allowedTCPPorts = [
            80
            443
          ];

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

      caclienth2o =
        { config, pkgs, ... }:
        {
          security.acme = {
            acceptTerms = true;
            defaults = {
              server = "https://caserver:8443/acme/acme/directory";
              email = "root@example.org";
            };
          };
          security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];

          networking.firewall.allowedTCPPorts = [
            80
            443
          ];

          services.h2o = {
            enable = true;
            hosts."caclienth2o" = {
              tls.policy = "force";
              acme.enable = true;
              settings = {
                paths."/" = {
                  "file.file" = "${pkgs.writeTextFile {
                    name = "h2o_welcome.txt";
                    text = "Welcome to H2O!";
                  }}";
                };
              };
            };
          };
        };

      catester =
        { config, pkgs, ... }:
        {
          security.pki.certificateFiles = [ "${test-certificates}/root_ca.crt" ];
        };
    };

    testScript = # python
      ''
        catester.start()
        caserver.wait_for_unit("step-ca.service")
        caserver.wait_until_succeeds("journalctl -o cat -u step-ca.service | grep '${pkgs.step-ca.version}'")

        caclient.wait_for_unit("acme-finished-caclient.target")
        catester.succeed("curl https://caclient/ | grep \"Welcome to nginx!\"")

        caclientcaddy.wait_for_unit("caddy.service")
        # It's hard to know when caddy has finished the ACME
        # dance with step-ca, so we keep trying to curl
        # until succeess.
        catester.wait_until_succeeds("curl https://caclientcaddy/ | grep \"Welcome to Caddy!\"")

        caclienth2o.wait_for_unit("acme-finished-caclienth2o.target")
        # TODO: Certificate Error despite output for lego showing success
        #
        # Good:
        # The server validated our request
        # acme: Validations succeeded; requesting certificates
        # Server responded with a certificate.
        # Finished Renew ACME certificate for caclienth2o.
        # Reached target acme-finished-caclienth2o.target.
        #
        # Bad:
        # curl: (60) SSL certificate problem: self-signed certificate in certificate chain
        # More details here: https://curl.se/docs/sslcerts.html
        #
        # curl failed to verify the legitimacy of the server and therefore could not
        # establish a secure connection to it. To learn more about this situation and
        # how to fix it, please visit the webpage mentioned above.
        catester.succeed("curl --insecure https://caclienth2o/ | grep \"Welcome to H2O!\"")
      '';
  }
)
