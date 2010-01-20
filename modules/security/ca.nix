{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    environment.etc = singleton
      { source = "${pkgs.cacert}/etc/ca-bundle.crt";
        target = "ca-bundle.crt";
      };

    environment.shellInit =
      ''
        export CURL_CA_BUNDLE=/etc/ca-bundle.crt
      '';
      
  };

}
