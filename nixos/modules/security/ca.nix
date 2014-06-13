{ config, lib, pkgs, ... }:

with lib;

{

  config = {

    environment.etc =
      [ { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ssl/certs/ca-bundle.crt";
        }
      ];

    environment.sessionVariables =
      { OPENSSL_X509_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
        CURL_CA_BUNDLE         = "/etc/ssl/certs/ca-bundle.crt";
        GIT_SSL_CAINFO         = "/etc/ssl/certs/ca-bundle.crt";
      };

  };

}
