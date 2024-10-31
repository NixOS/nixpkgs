{ config, options, lib, ... }:
{

  ###### interface

  options = {

    services.mail = {

      sendmailSetuidWrapper = lib.mkOption {
        type = lib.types.nullOr options.security.wrappers.type.nestedTypes.elemType;
        default = null;
        internal = true;
        description = ''
          Configuration for the sendmail setuid wapper.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf (config.services.mail.sendmailSetuidWrapper != null) {

    security.wrappers.sendmail = config.services.mail.sendmailSetuidWrapper;

  };

}
