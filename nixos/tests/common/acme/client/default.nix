{ lib, nodes, pkgs, ... }:
let
  caCert = nodes.acme.test-support.acme.caCert;
  caDomain = nodes.acme.test-support.acme.caDomain;

in {
  security.acme = {
    acceptTerms = true;
    defaults = {
      server = "https://${caDomain}/dir";
      email = "hostmaster@example.test";
      # Avoid a random 0-8 minute sleep when testing renewals.
      # We are not using LE servers in testing so this is not
      # going to impact their load.
      # See https://github.com/go-acme/lego/issues/1656
      extraLegoRenewFlags = ["-no-random-sleep"];
    };
  };

  security.pki.certificateFiles = [ caCert ];
}
