{ config, lib, pkgs, ... }:

with lib;

let
  ldmcfg = config.services.xserver.displayManager.lightdm;
  cfg = ldmcfg.greeters.slick;

  inherit (pkgs) writeText;

  theme = cfg.theme.package;
  icons = cfg.iconTheme.package;
  font = cfg.font.package;
  cursors = cfg.cursorTheme.package;

  slickGreeterConf = writeText "slick-greeter.conf" ''
    [Greeter]
    background=${ldmcfg.background}
    theme-name=${cfg.theme.name}
    icon-theme-name=${cfg.iconTheme.name}
    font-name=${cfg.font.name}
    cursor-theme-name=${cfg.cursorTheme.name}
    cursor-theme-size=${toString cfg.cursorTheme.size}
    draw-user-backgrounds=${boolToString cfg.draw-user-backgrounds}
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.slick = {
      enable = mkEnableOption "lightdm-slick-greeter as the lightdm greeter";

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
            Name of the theme to use for the lightdm-slick-greeter.
          '';
        };
      };

      iconTheme = {
        package = mkOption {
          type = types.package;
          default = pkgs.gnome.adwaita-icon-theme;
          defaultText = literalExpression "pkgs.gnome.adwaita-icon-theme";
          description = ''
            The package path that contains the icon theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = ''
            Name of the icon theme to use for the lightdm-slick-greeter.
          '';
        };
      };

      font = {
        package = mkOption {
          type = types.package;
          default = pkgs.ubuntu_font_family;
          defaultText = literalExpression "pkgs.ubuntu_font_family";
          description = ''
            The package path that contains the font given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Ubuntu 11";
          description = ''
            Name of the font to use.
          '';
        };
      };

      cursorTheme = {
        package = mkOption {
          type = types.package;
          default = pkgs.gnome.adwaita-icon-theme;
          defaultText = literalExpression "pkgs.gnome.adwaita-icon-theme";
          description = ''
            The package path that contains the cursor theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = ''
            Name of the cursor theme to use for the lightdm-slick-greeter.
          '';
        };

        size = mkOption {
          type = types.int;
          default = 24;
          description = ''
            Size of the cursor theme to use for the lightdm-slick-greeter.
          '';
        };
      };

      draw-user-backgrounds = mkEnableOption "draw user backgrounds";

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the lightdm-slick-greeter.conf
          configuration file.
        '';
      };
    };
  };

  config = mkIf (ldmcfg.enable && cfg.enable) {
    services.xserver.displayManager.lightdm = {
      greeters.gtk.enable = false;
      greeter = mkDefault {
        package = pkgs.lightdm-slick-greeter.xgreeters;
        name = "lightdm-slick-greeter";
      };
    };

    environment.systemPackages = [
      cursors
      icons
      theme
    ];

    fonts.packages = [ font ];

    environment.etc."lightdm/slick-greeter.conf".source = slickGreeterConf;
  };
}
