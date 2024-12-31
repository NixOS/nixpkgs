{
  config,
  lib,
  pkgs,
  ...
}:
let
  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.mobile;
in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.mobile = {
      enable = lib.mkEnableOption "lightdm-mobile-greeter as the lightdm greeter";
    };
  };

  config = lib.mkIf (ldmcfg.enable && cfg.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter = lib.mkDefault {
      package = pkgs.lightdm-mobile-greeter.xgreeters;
      name = "lightdm-mobile-greeter";
    };
  };
}
