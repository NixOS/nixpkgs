{ config, lib, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = config.test-support.displayManager.auto;

in

{

  ###### interface

  options = {

    test-support.displayManager.auto = {

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

  config = {
    services.xserver.displayManager.autoLogin.enable = cfg.enable;
    services.xserver.displayManager.autoLogin.user   = cfg.user;
  };

}
