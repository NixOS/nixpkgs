{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {
  
    services.mail = {
    
      sendmailSetuidWrapper = mkOption {
        default = null;
        description = ''
          Configuration for the sendmail setuid wrwapper (like an element of
          security.setuidOwners)";
        '';
      };

    };

  };

  ###### implementation

  config = mkIf (config.services.mail.sendmailSetuidWrapper != null) {

    security.setuidOwners = [ config.services.mail.sendmailSetuidWrapper ];

  };

}
