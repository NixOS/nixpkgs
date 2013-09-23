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

    environment.variables.OPENSSL_X509_CERT_FILE.value = "/etc/ssl/certs/ca-bundle.crt";
    environment.variables.CURL_CA_BUNDLE.value = "/etc/ssl/certs/ca-bundle.crt";
    environment.variables.GIT_SSL_CAINFO.value = "/etc/ssl/certs/ca-bundle.crt";

  };

}
