{ pkgs, ... }:

let
  certs = import ../common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  imports = [ ../common/user-account.nix ];
  security.pki.certificateFiles = [
    certs.ca.cert
  ];
  networking.extraHosts = ''
    127.0.0.1 ${domain}
  '';
  networking.firewall.allowedTCPPorts = [
    25
    465
    993
  ];
  services.postfix = {
    enable = true;
    enableSubmission = true;
    enableSubmissions = true;
    tlsTrustedAuthorities = "${certs.ca.cert}";
    config.smtpd_tls_chain_files = [
      "${certs.${domain}.key}"
      "${certs.${domain}.cert}"
    ];
  };
  services.dovecot2 = {
    enable = true;
    enableImap = true;
    sslCACert = "${certs.ca.cert}";
    sslServerCert = "${certs.${domain}.cert}";
    sslServerKey = "${certs.${domain}.key}";
  };
}
