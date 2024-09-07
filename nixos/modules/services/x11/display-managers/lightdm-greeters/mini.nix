{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.mini;

  miniGreeterConf = pkgs.writeText "lightdm-mini-greeter.conf"
    ''
    [greeter]
    user = ${cfg.user}
    show-password-label = true
    password-label-text = Password:
    invalid-password-text = Invalid Password
    show-input-cursor = true
    password-alignment = right

    [greeter-hotkeys]
    mod-key = meta
    shutdown-key = s
    restart-key = r
    hibernate-key = h
    suspend-key = u

    [greeter-theme]
    font = Sans
    font-size = 1em
    font-weight = bold
    font-style = normal
    text-color = "#080800"
    error-color = "#F8F8F0"
    background-image = "${ldmcfg.background}"
    background-color = "#1B1D1E"
    window-color = "#F92672"
    border-color = "#080800"
    border-width = 2px
    layout-space = 15
    password-color = "#F8F8F0"
    password-background-color = "#1B1D1E"
    password-border-color = "#080800"
    password-border-width = 2px

    ${cfg.extraConfig}
    '';

in
{
  options = {

    services.xserver.displayManager.lightdm.greeters.mini = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable lightdm-mini-greeter as the lightdm greeter.

          Note that this greeter starts only the default X session.
          You can configure the default X session using
          [](#opt-services.displayManager.defaultSession).
        '';
      };

      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          The user to login as.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the lightdm-mini-greeter.conf
          configuration file.
        '';
      };

    };

  };

  config = mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = pkgs.lightdm-mini-greeter.xgreeters;
      name = "lightdm-mini-greeter";
    };

    environment.etc."lightdm/lightdm-mini-greeter.conf".source = miniGreeterConf;

  };
}
