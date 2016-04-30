{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.auto;

in

{

  ###### interface

  options = {

    services.xserver.displayManager.auto = {

      user = mkOption {
        default = "root";
        description = "The user account to login automatically.";
      };

    };

  };


  ###### implementation

  config = mkIf (dmcfg.enable == "auto") {

    services.xserver.displayManager.enable = "slim";
    services.xserver.displayManager.slim = {
      autoLogin = true;
      defaultUser = cfg.user;
    };

  };

}
