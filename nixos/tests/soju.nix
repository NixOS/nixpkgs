import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  domain = "soju.localdomain";
  user = "testuser";
  pass = "hunter2";

  tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 36500 \
      -subj '/CN=${domain}' -extensions v3_req \
      -addext 'subjectAltName = DNS:*.${domain}'
    install -D -t $out key.pem cert.pem
  '';
in
{
  name = "soju";
  meta.maintainers = with lib.maintainers; [ Benjamin-L ];

  nodes.machine = { ... }: {
    services.soju = {
      enable = true;
      adminSocket.enable = true;
      hostName = domain;
      tlsCertificate = "${tls-cert}/cert.pem";
      tlsCertificateKey = "${tls-cert}/key.pem";
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("soju")
    machine.wait_for_file("/run/soju/admin")

    machine.succeed("sojuctl user create -username ${user} -password ${pass}")
  '';
})
