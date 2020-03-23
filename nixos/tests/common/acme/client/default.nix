{ lib, nodes, pkgs, ... }:

let
  acme-ca = nodes.acme.config.test-support.acme.caCert;
in

{
  networking.nameservers = [
    nodes.acme.config.networking.primaryIPAddress
  ];

  security.acme = {
    server = "https://acme.test/dir";
    email = "hostmaster@example.test";
    acceptTerms = true;
  };

  security.pki.certificateFiles = [ acme-ca ];
}
