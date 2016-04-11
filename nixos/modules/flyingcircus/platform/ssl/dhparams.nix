{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.flyingcircus.ssl;
  dhparams_file = "ssl/dhparams.pem";

in

{

  options = {

    flyingcircus.ssl = {
      generate_dhparams = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to generate custom dhparams.";
      };
    };

  };

  config = {

    system.activationScripts = mkIf cfg.generate_dhparams {
       fc_dhparams = ''
         mkdir -p /etc/ssl/
         cd /etc
         if [ ! -e ${dhparams_file} ]; then
           ${pkgs.openssl}/bin/openssl dhparam -out ssl/.dhparams.pem 2048
           mv ssl/.dhparams.pem ${dhparams_file}
         fi
       '';
    };

    environment.etc = mkIf (!cfg.generate_dhparams) {
      # This is an insecure DH params file to support testing.
      # Taken from https://wiki.openssl.org/index.php/Diffie-Hellman_parameters
      "ssl/dhparams.pem".text = ''
        -----BEGIN DH PARAMETERS-----
        MIGHAoGBAP//////////yQ/aoiFowjTExmKLgNwc0SkCTgiKZ8x0Agu+pjsTmyJR
        Sgh5jjQE3e+VGbPNOkMbMCsKbfJfFDdP4TVtbVHCReSFtXZiXn7G9ExC6aY37WsL
        /1y29Aa37e44a/taiZ+lrp8kEXxLH+ZJKGZR7OZTgf//////////AgEC
        -----END DH PARAMETERS-----
      '';
    };

  };

}
