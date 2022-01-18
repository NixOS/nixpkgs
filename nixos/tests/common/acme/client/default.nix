{ lib, nodes, pkgs, ... }:
let
  caCert = nodes.acme.config.test-support.acme.caCert;
  caDomain = nodes.acme.config.test-support.acme.caDomain;

in {
  security.acme = {
    acceptTerms = true;
    defaults = {
      server = "https://${caDomain}/dir";
      email = "hostmaster@example.test";
    };
  };

  security.pki.certificateFiles = [ caCert ];
}
