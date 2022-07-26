{ config, options, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.mail = {

      sendmailSetuidWrapper = mkOption {
        type = types.nullOr options.security.wrappers.type.nestedTypes.elemType;
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

    security.wrappers.sendmail = config.services.mail.sendmailSetuidWrapper;

  };

}
