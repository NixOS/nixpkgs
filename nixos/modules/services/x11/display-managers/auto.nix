{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.auto;

in

{

  ###### interface

  options = {

    services.xserver.displayManager.select = mkOption {
      type = with types; nullOr (enum [ "auto" ]);
    };

    services.xserver.displayManager.auto = {

      user = mkOption {
        default = "root";
        description = "The user account to login automatically.";
      };

    };

  };

  config = mkIf (dmcfg.select == "auto") {
    services.xserver.displayManager.slim = {
      enabled     = true;
      autoLogin   = true;
      defaultUser = cfg.user;
    };
  };

}
