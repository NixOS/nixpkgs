{ nodes, config, ... }:

let
  certs = import ../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  security.pki.certificateFiles = [
    certs.ca.cert
  ];
  networking.extraHosts = ''
    ${nodes.server.networking.primaryIPAddress} ${domain}
  '';
  services.alps = {
    enable = true;
    theme = "alps";
    imaps = {
      host = domain;
      port = 993;
    };
    smtps = {
      host = domain;
      port = 465;
    };
  };
}
