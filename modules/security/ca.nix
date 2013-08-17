{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.etc =
      [
        # Provide both Fedora and Ubuntu certificate locations for
        # compatibility.
        { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ssl/certs/ca-bundle.crt"; # Same location as in Fedora
        }

        { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ssl/certs/ca-certificates.crt"; # Same location as in Ubuntu
        }

        # Backward compatibility; may remove at some point.
        { source = "${pkgs.cacert}/etc/ca-bundle.crt";
          target = "ca-bundle.crt";
        }
      ];

    environment.shellInit =
      ''
        export OPENSSL_X509_CERT_FILE=/etc/ssl/certs/ca-bundle.crt

        export CURL_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt
        export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
      '';

  };

}
