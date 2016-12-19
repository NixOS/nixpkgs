{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.mail = {

      sendmailSetuidWrapper = mkOption {
        default = null;
        internal = true;
        description = ''
          Configuration for the sendmail setuid wapper.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf (config.services.mail.sendmailSetuidWrapper != null) {

    security.setuidOwners = [ config.services.mail.sendmailSetuidWrapper ];

  };

}
