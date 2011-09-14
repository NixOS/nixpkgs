{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.etc =
      [ { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ssl/certs/ca-bundle.crt";
        }

        # Backward compatibility; may remove at some point.
        { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ca-bundle.crt";
        }
      ];

    environment.shellInit =
      ''
        export OPENSSL_X509_CERT_FILE=/etc/ssl/certs/ca-bundle.crt

        # !!! Remove the following as soon as OpenSSL 1.0.0e is the default.
        export CURL_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt
        export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
      '';

  };

}
