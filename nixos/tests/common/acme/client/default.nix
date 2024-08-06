{ nodes, ... }:
let
  caCert = nodes.acme.test-support.acme.caCert;
  caDomain = nodes.acme.test-support.acme.caDomain;

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
