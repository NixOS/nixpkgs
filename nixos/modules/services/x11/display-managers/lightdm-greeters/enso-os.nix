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
  cfg = ldmcfg.greeters.enso;

  theme = cfg.theme.package;
  icons = cfg.iconTheme.package;
  cursors = cfg.cursorTheme.package;

  ensoGreeterConf = pkgs.writeText "lightdm-enso-os-greeter.conf" ''
    [greeter]
    default-wallpaper=${ldmcfg.background}
    gtk-theme=${cfg.theme.name}
    icon-theme=${cfg.iconTheme.name}
    cursor-theme=${cfg.cursorTheme.name}
    blur=${toString cfg.blur}
    brightness=${toString cfg.brightness}
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.enso = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable enso-os-greeter as the lightdm greeter
        '';
      };

      theme = {
        package = mkOption {
          type = types.package;
          default = pkgs.gnome.gnome-themes-extra;
          defaultText = literalExpression "pkgs.gnome.gnome-themes-extra";
          description = ''
            The package path that contains the theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = ''
            Name of the theme to use for the lightdm-enso-os-greeter
          '';
        };
      };

      iconTheme = {
        package = mkOption {
          type = types.package;
          default = pkgs.papirus-icon-theme;
          defaultText = literalExpression "pkgs.papirus-icon-theme";
          description = ''
            The package path that contains the icon theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "ePapirus";
          description = ''
            Name of the icon theme to use for the lightdm-enso-os-greeter
          '';
        };
      };

      cursorTheme = {
        package = mkOption {
          type = types.package;
          default = pkgs.capitaine-cursors;
          defaultText = literalExpression "pkgs.capitaine-cursors";
          description = ''
            The package path that contains the cursor theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "capitane-cursors";
          description = ''
            Name of the cursor theme to use for the lightdm-enso-os-greeter
          '';
        };
      };

      blur = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable blur
        '';
      };

      brightness = mkOption {
        type = types.int;
        default = 7;
        description = ''
          Brightness
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the greeter.conf
          configuration file
        '';
      };
    };
  };

  config = mkIf (ldmcfg.enable && cfg.enable) {
    environment.etc."lightdm/greeter.conf".source = ensoGreeterConf;

    environment.systemPackages = [
      cursors
      icons
      theme
    ];

    services.xserver.displayManager.lightdm = {
      greeter = mkDefault {
        package = pkgs.lightdm-enso-os-greeter.xgreeters;
        name = "pantheon-greeter";
      };

      greeters = {
        gtk = {
          enable = mkDefault false;
        };
      };
    };
  };
}
