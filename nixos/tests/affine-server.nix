{ lib, ... }:

let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  inherit (certs) domain;
in

{
  name = "affine-server";

  meta.maintainers = with lib.maintainers; [
    vagahbond
  ];

  nodes.machine = {
    virtualisation.memorySize = 2048;

    networking.hosts."127.0.0.1" = [ domain ];
    security.pki.certificateFiles = [ certs.ca.cert ];

    services.nginx.virtualHosts."${domain}" = {
      forceSSL = lib.mkForce true;
      sslCertificate = certs.${domain}.cert;
      sslCertificateKey = certs.${domain}.key;

    };

    services.affine-server = {
      enable = true;

      nginx = {
        enable = true;
        enableACME = false;
      };
      database.createLocally = true;

      redis.createLocally = true;

      settings = {
        server.host = domain;
        server.https = true;
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("affine-server.service")
    machine.wait_for_open_port(3210)
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(443)

    with subtest("HTTPS endpoint responds"):
        machine.wait_until_succeeds(
            "curl --fail --silent --show-error --location --max-time 10 "
            "https://${domain}/ --output /dev/null",
            timeout=120,
        )
  '';
}
