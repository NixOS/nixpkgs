{ lib, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  mobilizonDomain = certs.domain;
  port = 41395;
in

{
  name = "mobilizon";
  meta.maintainers = with lib.maintainers; [
    minijackson
    erictapen
  ];

  nodes.server =
    { ... }:
    {
      services.mobilizon = {
        enable = true;
        settings = {
          ":mobilizon" = {
            ":instance" = {
              name = "Test Mobilizon";
              hostname = mobilizonDomain;
            };
            "Mobilizon.Web.Endpoint".http.port = port;
          };
        };
      };

      security.pki.certificateFiles = [ certs.ca.cert ];

      services.nginx.virtualHosts."${mobilizonDomain}" = {
        enableACME = lib.mkForce false;
        sslCertificate = certs.${mobilizonDomain}.cert;
        sslCertificateKey = certs.${mobilizonDomain}.key;
      };

      networking.hosts."::1" = [ mobilizonDomain ];
    };

  testScript = ''
    server.wait_for_unit("mobilizon.service")
    server.wait_for_open_port(${toString port})
    server.succeed("curl --fail https://${mobilizonDomain}/")
  '';
}
