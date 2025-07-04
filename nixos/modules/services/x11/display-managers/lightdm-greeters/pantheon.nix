{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.pantheon;

in
{
  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };

  options = {

    services.xserver.displayManager.lightdm.greeters.pantheon = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable elementary-greeter as the lightdm greeter.
        '';
      };

    };

  };

  config = mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = pkgs.pantheon.elementary-greeter.xgreeters;
      name = "io.elementary.greeter";
    };

    # Show manual login card.
    services.xserver.displayManager.lightdm.extraSeatDefaults = "greeter-show-manual-login=true";

    environment.etc."lightdm/io.elementary.greeter.conf".source =
      "${pkgs.pantheon.elementary-greeter}/etc/lightdm/io.elementary.greeter.conf";
    environment.etc."wingpanel.d/io.elementary.greeter.allowed".source =
      "${pkgs.pantheon.elementary-default-settings}/etc/wingpanel.d/io.elementary.greeter.allowed";

  };
}
