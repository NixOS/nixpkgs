{ ... }:
let
  domain = "example.test";
in
{
  name = "nginx-acme";

  nodes = {
    acme =
      { nodes, ... }:
      {
        imports = [ ./common/acme/server ];
      };

    webserver =
      {
        nodes,
        config,
        lib,
        pkgs,
        ...
      }:
      let
        fqdn = config.networking.fqdn;
      in
      {
        security.pki.certificateFiles = [ nodes.acme.test-support.acme.caCert ];
        services.resolved.enable = true;
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
        networking.domain = domain;
        environment.systemPackages = [ pkgs.openssl ];
        services.nginx = {
          enable = true;
          package = pkgs.nginx.override {
            withDebug = true;
          };
          additionalModules = [ pkgs.nginxModules.acme ];
          # logError = "stderr debug";
          appendHttpConfig = ''
            resolver 127.0.0.53:53;
            acme_issuer default {
              uri         https://${nodes.acme.test-support.acme.caDomain}/dir;
              state_path  /var/cache/nginx/acme;
              accept_terms_of_service;
            }
            acme_shared_zone zone=ngx_acme_shared:1M;
            server {
              server_name ${fqdn};
              # listener on port 80 is required to process ACME HTTP-01 challenges
              listen 0.0.0.0:80;
              listen [::0]:80;

              location / {
                return 404;
              }
            }
          '';
          virtualHosts."${fqdn}" =
            let
              testroot = pkgs.runCommand "testroot" { } ''
                mkdir -p $out
                echo "<html><body>Hello World!</body></html>" > $out/index.html
              '';
            in
            {
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 443;
                  ssl = true;
                }
                {
                  addr = "[::0]";
                  port = 443;
                  ssl = true;
                }
              ];
              root = testroot;
              extraConfig = ''
                acme_certificate default;

                ssl_certificate $acme_certificate;
                ssl_certificate_key $acme_certificate_key;
              '';
            };
        };
      };
  };
  testScript =
    { nodes, ... }:
    ''
      ${(import acme/utils.nix).pythonUtils}

      ca_domain = "${nodes.acme.test-support.acme.caDomain}"
      fqdn = "${nodes.webserver.networking.fqdn}"

      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)

      webserver.start()
      webserver.wait_for_unit("nginx")
      download_ca_certs(webserver, ca_domain)
      check_connection(webserver, fqdn)
    '';
}
