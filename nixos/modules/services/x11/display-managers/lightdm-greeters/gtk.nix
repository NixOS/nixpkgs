{ config, lib, pkgs, ... }:

with lib;

let

  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  xcfg = config.services.xserver;
  cfg = ldmcfg.greeters.gtk;

  inherit (pkgs) writeText;

  theme = cfg.theme.package;
  icons = cfg.iconTheme.package;
  cursors = cfg.cursorTheme.package;

  gtkGreeterConf = writeText "lightdm-gtk-greeter.conf"
    ''
    [greeter]
    theme-name = ${cfg.theme.name}
    icon-theme-name = ${cfg.iconTheme.name}
    cursor-theme-name = ${cfg.cursorTheme.name}
    cursor-theme-size = ${toString cfg.cursorTheme.size}
    background = ${ldmcfg.background}
    ${optionalString (cfg.clock-format != null) "clock-format = ${cfg.clock-format}"}
    ${optionalString (cfg.indicators != null) "indicators = ${concatStringsSep ";" cfg.indicators}"}
    ${optionalString (xcfg.dpi != null) "xft-dpi=${toString xcfg.dpi}"}
    ${cfg.extraConfig}
    '';

in
{
  options = {

    services.xserver.displayManager.lightdm.greeters.gtk = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable lightdm-gtk-greeter as the lightdm greeter.
        '';
      };

      theme = {

        package = mkOption {
          type = types.package;
          default = pkgs.gnome.gnome-themes-extra;
          defaultText = literalExpression "pkgs.gnome.gnome-themes-extra";
          description = lib.mdDoc ''
            The package path that contains the theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = lib.mdDoc ''
            Name of the theme to use for the lightdm-gtk-greeter.
          '';
        };

      };

      iconTheme = {

        package = mkOption {
          type = types.package;
          default = pkgs.gnome.adwaita-icon-theme;
          defaultText = literalExpression "pkgs.gnome.adwaita-icon-theme";
          description = lib.mdDoc ''
            The package path that contains the icon theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = lib.mdDoc ''
            Name of the icon theme to use for the lightdm-gtk-greeter.
          '';
        };

      };

      cursorTheme = {

        package = mkOption {
          type = types.package;
          default = pkgs.gnome.adwaita-icon-theme;
          defaultText = literalExpression "pkgs.gnome.adwaita-icon-theme";
          description = lib.mdDoc ''
            The package path that contains the cursor theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = lib.mdDoc ''
            Name of the cursor theme to use for the lightdm-gtk-greeter.
          '';
        };

        size = mkOption {
          type = types.int;
          default = 16;
          description = lib.mdDoc ''
            Size of the cursor theme to use for the lightdm-gtk-greeter.
          '';
        };
      };

      clock-format = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "%F";
        description = lib.mdDoc ''
          Clock format string (as expected by strftime, e.g. "%H:%M")
          to use with the lightdm gtk greeter panel.

          If set to null the default clock format is used.
        '';
      };

      indicators = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = [ "~host" "~spacer" "~clock" "~spacer" "~session" "~language" "~a11y" "~power" ];
        description = lib.mdDoc ''
          List of allowed indicator modules to use for the lightdm gtk
          greeter panel.

          Built-in indicators include "~a11y", "~language", "~session",
          "~power", "~clock", "~host", "~spacer". Unity indicators can be
          represented by short name (e.g. "sound", "power"), service file name,
          or absolute path.

          If set to null the default indicators are used.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration that should be put in the lightdm-gtk-greeter.conf
          configuration file.
        '';
      };

    };

  };

  config = mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeter = mkDefault {
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
