{ config, lib, pkgs, ... }:

with lib;
let
  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.mobile;
in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.mobile = {
      enable = mkEnableOption
        "lightdm-mobile-greeter as the lightdm greeter";
    };
  };

  config = mkIf (ldmcfg.enable && cfg.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = pkgs.lightdm-mobile-greeter.xgreeters;
      name = "lightdm-mobile-greeter";
    };
  };
}
