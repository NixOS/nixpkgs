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
        export CURL_CA_BUNDLE=/etc/ssl/certs/ca-bundle.crt
        export GIT_SSL_CAINFO=/etc/ssl/certs/ca-bundle.crt
      '';
      
  };

}
