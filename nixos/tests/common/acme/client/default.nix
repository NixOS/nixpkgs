{ lib, nodes, pkgs, ... }:
let
  caCert = nodes.acme.config.test-support.acme.caCert;
  caDomain = nodes.acme.config.test-support.acme.caDomain;

in {
  security.acme = {
    server = "https://${caDomain}/dir";
    email = "hostmaster@example.test";
    acceptTerms = true;
  };

  security.pki.certificateFiles = [ caCert ];
}
