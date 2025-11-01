{ ... }:
let
  domain = "example.test";
  makeNginxConfig =
    challenge:
    {
      nodes,
      config,
      lib,
      pkgs,
      ...
    }:
    let
      fqdn = config.networking.fqdn;
      httpChallenge = challenge == "http";
    in
    {
      security.pki.certificateFiles = [ nodes.acme.test-support.acme.caCert ];
      services.resolved.enable = true;
      networking.firewall.allowedTCPPorts = [
        443
      ]
      ++ lib.optionals httpChallenge [ 80 ];
      networking.domain = domain;
      environment.systemPackages = [ pkgs.openssl ];
      services.nginx = {
        enable = true;
        additionalModules = [ pkgs.nginxModules.acme ];
        resolver.addresses = [ "127.0.0.53:53" ];
        appendHttpConfig = ''
          acme_issuer default {
            uri         https://${nodes.acme.test-support.acme.caDomain}/dir;
            state_path  /var/cache/nginx/acme;
            accept_terms_of_service;
            challenge ${challenge};
          }
          acme_shared_zone zone=ngx_acme_shared:1M;
        ''
        + lib.optionalString httpChallenge ''
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
in
{
  name = "nginx-acme";

  nodes = {
    acme =
      { ... }:
      {
        imports = [ ./common/acme/server ];
      };

    webserverhttpchallenge = makeNginxConfig "http";

    webservertlschallenge = makeNginxConfig "tls-alpn";
  };
  testScript =
    { nodes, ... }:
    ''
      ${(import acme/utils.nix).pythonUtils}

      ca_domain = "${nodes.acme.test-support.acme.caDomain}"
      fqdn_http_challenge = "${nodes.webserverhttpchallenge.networking.fqdn}"
      fqdn_tls_challenge = "${nodes.webservertlschallenge.networking.fqdn}"

      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)

      webserverhttpchallenge.start()
      webservertlschallenge.start()

      webserverhttpchallenge.wait_for_unit("nginx")
      download_ca_certs(webserverhttpchallenge, ca_domain)
      check_connection(webserverhttpchallenge, fqdn_http_challenge)

      webservertlschallenge.wait_for_unit("nginx")
      download_ca_certs(webservertlschallenge, ca_domain)
      check_connection(webservertlschallenge, fqdn_tls_challenge)
    '';
}
