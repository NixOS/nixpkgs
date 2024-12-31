{
  config,
  lib,
  pkgs,
  ...
}:
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
    draw-user-backgrounds=${lib.boolToString cfg.draw-user-backgrounds}
    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.xserver.displayManager.lightdm.greeters.slick = {
      enable = lib.mkEnableOption "lightdm-slick-greeter as the lightdm greeter";

      theme = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.gnome-themes-extra;
          defaultText = lib.literalExpression "pkgs.gnome-themes-extra";
          description = ''
            The package path that contains the theme given in the name option.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "Adwaita";
          description = ''
            Name of the theme to use for the lightdm-slick-greeter.
          '';
        };
      };

      iconTheme = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.adwaita-icon-theme;
          defaultText = lib.literalExpression "pkgs.adwaita-icon-theme";
          description = ''
            The package path that contains the icon theme given in the name option.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "Adwaita";
          description = ''
            Name of the icon theme to use for the lightdm-slick-greeter.
          '';
        };
      };

      font = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.ubuntu-classic;
          defaultText = lib.literalExpression "pkgs.ubuntu-classic";
          description = ''
            The package path that contains the font given in the name option.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "Ubuntu 11";
          description = ''
            Name of the font to use.
          '';
        };
      };

      cursorTheme = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.adwaita-icon-theme;
          defaultText = lib.literalExpression "pkgs.adwaita-icon-theme";
          description = ''
            The package path that contains the cursor theme given in the name option.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "Adwaita";
          description = ''
            Name of the cursor theme to use for the lightdm-slick-greeter.
          '';
        };

        size = lib.mkOption {
          type = lib.types.int;
          default = 24;
          description = ''
            Size of the cursor theme to use for the lightdm-slick-greeter.
          '';
        };
      };

      draw-user-backgrounds = lib.mkEnableOption "draw user backgrounds";

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the lightdm-slick-greeter.conf
          configuration file.
        '';
      };
    };
  };

  config = lib.mkIf (ldmcfg.enable && cfg.enable) {
    services.xserver.displayManager.lightdm = {
      greeters.gtk.enable = false;
      greeter = lib.mkDefault {
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
