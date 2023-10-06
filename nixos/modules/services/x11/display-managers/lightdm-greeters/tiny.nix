{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.tiny;

in
{
  options = {

    services.xserver.displayManager.lightdm.greeters.tiny = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable lightdm-tiny-greeter as the lightdm greeter.

          Note that this greeter starts only the default X session.
          You can configure the default X session using
          [](#opt-services.xserver.displayManager.defaultSession).
        '';
      };

      label = {
        user = mkOption {
          type = types.str;
          default = "Username";
          description = lib.mdDoc ''
            The string to represent the user_text label.
          '';
        };

        pass = mkOption {
          type = types.str;
          default = "Password";
          description = lib.mdDoc ''
            The string to represent the pass_text label.
          '';
        };
      };


      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Section to describe style and ui.
        '';
      };

    };

  };

  config = mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    nixpkgs.config.lightdm-tiny-greeter.conf =
    let
      configHeader = ''
        #include <gtk/gtk.h>
        static const char *user_text = "${cfg.label.user}";
        static const char *pass_text = "${cfg.label.pass}";
        static const char *session = "${dmcfg.defaultSession}";
      '';
    in
      optionalString (cfg.extraConfig != "")
        (configHeader + cfg.extraConfig);

    services.xserver.displayManager.lightdm.greeter =
      mkDefault {
        package = pkgs.lightdm-tiny-greeter.xgreeters;
        name = "lightdm-tiny-greeter";
      };

    assertions = [
      {
        assertion = dmcfg.defaultSession != null;
        message = ''
          Please set: services.xserver.displayManager.defaultSession
        '';
      }
    ];

  };
}
