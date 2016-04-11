{ config, lib, pkgs, ... }:

{
  system.activationScripts = {
     fc_dhparams = ''
       mkdir -p /etc/ssl/
       PARAMS=/etc/ssl/dhparams.pem
       if [ ! -e $PARAMS ]; then
         ${pkgs.openssl}/bin/openssl dhparam -out /etc/ssl/.dhparams.pem 2048
         mv /etc/ssl/.dhparams.pem $PARAMS
       fi
     '';
  };

}
