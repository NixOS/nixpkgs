{ lib, nodes, pkgs, ... }: let
  letsencrypt-ca = nodes.letsencrypt.config.test-support.letsencrypt.caCert;
in {
  networking.nameservers = [
    nodes.letsencrypt.config.networking.primaryIPAddress
  ];

  security.pki.certificateFiles = [ letsencrypt-ca ];
}
