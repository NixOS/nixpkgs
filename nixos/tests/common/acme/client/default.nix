{ lib, nodes, pkgs, ... }:

let
  acme-ca = nodes.acme.config.test-support.acme.caCert;
in

{
  security.acme = {
    server = "https://acme.test/dir";
    email = "hostmaster@example.test";
    acceptTerms = true;
  };

  security.pki.certificateFiles = [ acme-ca ];
}
