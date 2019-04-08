{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.pantheon;

  xgreeters = pkgs.linkFarm "pantheon-greeter-xgreeters" [{
    path = "${pkgs.pantheon.elementary-greeter}/share/xgreeters/io.elementary.greeter.desktop";
    name = "io.elementary.greeter.desktop";
  }];

in
{
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
      package = xgreeters;
      name = "io.elementary.greeter";
    };

    environment.etc."lightdm/io.elementary.greeter.conf".source = "${pkgs.pantheon.elementary-greeter}/etc/lightdm/io.elementary.greeter.conf";
    environment.etc."wingpanel.d/io.elementary.greeter.whitelist".source = "${pkgs.pantheon.elementary-default-settings}/etc/wingpanel.d/io.elementary.greeter.whitelist";

  };
}
