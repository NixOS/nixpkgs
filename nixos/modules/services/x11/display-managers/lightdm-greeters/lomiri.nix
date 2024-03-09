{ config, lib, pkgs, ... }:

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.lomiri;

in
{
  meta.maintainers = lib.teams.lomiri.members;

  options = {
    services.xserver.displayManager.lightdm.greeters.lomiri = {
      enable = lib.mkEnableOption (lib.mdDoc "lomiri's greeter as the lightdm greeter");
    };
  };

  config = lib.mkIf (ldmcfg.enable && cfg.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter = lib.mkDefault {
      package = pkgs.lomiri.lomiri.greeter;
      name = "lomiri-greeter";
    };

    # Greeter needs to be run through its wrapper
    # Greeter doesn't work with our set-session.py script, need to set default user-session
    services.xserver.displayManager.lightdm.extraSeatDefaults = ''
      greeter-wrapper = ${lib.getExe' pkgs.lomiri.lomiri "lomiri-greeter-wrapper"}
      user-session = ${dmcfg.defaultSession}
    '';
  };
}
