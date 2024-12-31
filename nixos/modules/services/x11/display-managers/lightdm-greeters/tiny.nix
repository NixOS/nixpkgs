{
  config,
  lib,
  pkgs,
  ...
}:
let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.tiny;

in
{
  options = {

    services.xserver.displayManager.lightdm.greeters.tiny = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable lightdm-tiny-greeter as the lightdm greeter.

          Note that this greeter starts only the default X session.
          You can configure the default X session using
          [](#opt-services.displayManager.defaultSession).
        '';
      };

      label = {
        user = lib.mkOption {
          type = lib.types.str;
          default = "Username";
          description = ''
            The string to represent the user_text label.
          '';
        };

        pass = lib.mkOption {
          type = lib.types.str;
          default = "Password";
          description = ''
            The string to represent the pass_text label.
          '';
        };
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Section to describe style and ui.
        '';
      };

    };

  };

  config = lib.mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeters.gtk.enable = false;

    services.xserver.displayManager.lightdm.greeter =
      let
        configHeader = ''
          #include <gtk/gtk.h>
          static const char *user_text = "${cfg.label.user}";
          static const char *pass_text = "${cfg.label.pass}";
          static const char *session = "${dmcfg.defaultSession}";
        '';
        config = lib.optionalString (cfg.extraConfig != "") (configHeader + cfg.extraConfig);
        package = pkgs.lightdm-tiny-greeter.override { conf = config; };
      in
      lib.mkDefault {
        package = package.xgreeters;
        name = "lightdm-tiny-greeter";
      };

    assertions = [
      {
        assertion = dmcfg.defaultSession != null;
        message = ''
          Please set: services.displayManager.defaultSession
        '';
      }
    ];

  };
}
