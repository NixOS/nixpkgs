{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.etc =
      [ { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ssl/certs/ca-bundle.crt";
        }
      ];

    environment.variables.OPENSSL_X509_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    environment.variables.CURL_CA_BUNDLE = "/etc/ssl/certs/ca-bundle.crt";
    environment.variables.GIT_SSL_CAINFO = "/etc/ssl/certs/ca-bundle.crt";

  };

}
