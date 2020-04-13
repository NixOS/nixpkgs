{ lib, nodes, pkgs, ... }: let
  letsencrypt-ca = nodes.letsencrypt.config.test-support.letsencrypt.caCert;
in {
  networking.nameservers = [
    nodes.letsencrypt.config.networking.primaryIPAddress
  ];

  security.acme.acceptTerms = true;
  security.acme.email = "webmaster@example.com";

  security.pki.certificateFiles = [ letsencrypt-ca ];
}
