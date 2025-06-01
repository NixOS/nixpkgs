{ pkgs, lib, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;

  user = "testuser";
  pass = "hunter2";
in
{
  name = "soju";
  meta.maintainers = [ ];

  nodes.machine =
    { ... }:
    {
      services.soju = {
        enable = true;
        adminSocket.enable = true;
        hostName = domain;
        tlsCertificate = certs.${domain}.cert;
        tlsCertificateKey = certs.${domain}.key;
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("soju")
    machine.wait_for_file("/run/soju/admin")

    machine.succeed("sojuctl user create -username ${user} -password ${pass}")
  '';
}
