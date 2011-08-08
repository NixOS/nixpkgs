{ config, pkgs, ... }:

with pkgs.lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.auto;

in

{

  ###### interface

  options = {
  
    services.xserver.displayManager.auto = {
    
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the fake "auto" display manager, which
          automatically logs in the user specified in the
          <option>user</option> option.  This is mostly useful for
          automated tests.
        '';
      };

      user = mkOption {
        default = "root";
        description = "The user account to login automatically.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.displayManager.slim.enable = false;
  
    services.xserver.displayManager.job =
      { execCmd =
          ''
            exec ${pkgs.xorg.xinit}/bin/xinit \
              ${pkgs.su}/bin/su -c ${dmcfg.session.script} ${cfg.user} \
              -- ${dmcfg.xserverBin} ${dmcfg.xserverArgs}
          '';
      };

    # The ConsoleKit PAM connector launches a local session, but it's
    # not set as "active" (maybe because x11-display-device is not
    # set).  Launching a child session seems to fix that.
    services.xserver.displayManager.forceCKSession = true;
    
  };

}
