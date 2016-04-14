{ config, lib, pkgs, ... }:
with lib;

{

  options = {

    flyingcircus.ssl = {
      certificates = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of hosts to generate certificates for.";
      };
    };

  };

  config = {
     system.activationScripts = {
        fc_ssl_certificates = ''
          mkdir -p /etc/ssl/
          export OPENSSL_CNF=${./openssl.cnf}
          for host in ${toString config.flyingcircus.ssl.certificates}; do
            if [ -e /etc/ssl/$host.crt ]; then continue; fi
            ${pkgs.openssl}/bin/openssl req \
              -new -nodes -newkey rsa:4096 -keyout /etc/ssl/$host.key \
              -x509 -days 999 -subj "/CN=$host" -out /etc/ssl/$host.crt
          done
        '';
     };
  };

}
