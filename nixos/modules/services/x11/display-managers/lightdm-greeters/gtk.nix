{
  config,
  lib,
  pkgs,
  ...
}:
let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  xcfg = config.services.xserver;
  cfg = ldmcfg.greeters.gtk;

  inherit (pkgs) writeText;

  theme = cfg.theme.package;
  icons = cfg.iconTheme.package;
  cursors = cfg.cursorTheme.package;

  gtkGreeterConf = writeText "lightdm-gtk-greeter.conf" ''
    [greeter]
    theme-name = ${cfg.theme.name}
    icon-theme-name = ${cfg.iconTheme.name}
    cursor-theme-name = ${cfg.cursorTheme.name}
    cursor-theme-size = ${toString cfg.cursorTheme.size}
    background = ${ldmcfg.background}
    ${lib.optionalString (cfg.clock-format != null) "clock-format = ${cfg.clock-format}"}
    ${lib.optionalString (
      cfg.indicators != null
    ) "indicators = ${lib.concatStringsSep ";" cfg.indicators}"}
    ${lib.optionalString (xcfg.dpi != null) "xft-dpi=${toString xcfg.dpi}"}
    ${cfg.extraConfig}
  '';

in
{
  options = {

    services.xserver.displayManager.lightdm.greeters.gtk = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable lightdm-gtk-greeter as the lightdm greeter.
        '';
      };

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
            Name of the theme to use for the lightdm-gtk-greeter.
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
            Name of the icon theme to use for the lightdm-gtk-greeter.
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
            Name of the cursor theme to use for the lightdm-gtk-greeter.
          '';
        };

        size = lib.mkOption {
          type = lib.types.int;
          default = 16;
          description = ''
            Size of the cursor theme to use for the lightdm-gtk-greeter.
          '';
        };
      };

      clock-format = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "%F";
        description = ''
          Clock format string (as expected by strftime, e.g. "%H:%M")
          to use with the lightdm gtk greeter panel.

          If set to null the default clock format is used.
        '';
      };

      indicators = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        example = [
          "~host"
          "~spacer"
          "~clock"
          "~spacer"
          "~session"
          "~language"
          "~a11y"
          "~power"
        ];
        description = ''
          List of allowed indicator modules to use for the lightdm gtk
          greeter panel.

          Built-in indicators include "~a11y", "~language", "~session",
          "~power", "~clock", "~host", "~spacer". Unity indicators can be
          represented by short name (e.g. "sound", "power"), service file name,
          or absolute path.

          If set to null the default indicators are used.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the lightdm-gtk-greeter.conf
          configuration file.
        '';
      };

    };

  };

  config = lib.mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeter = lib.mkDefault {
      package = pkgs.lightdm-gtk-greeter.xgreeters;
      name = "lightdm-gtk-greeter";
    };

    environment.systemPackages = [
      cursors
      icons
      theme
    ];

    environment.etc."lightdm/lightdm-gtk-greeter.conf".source = gtkGreeterConf;

  };
}
