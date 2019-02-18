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

  # The default greeter provided with this expression is the GTK greeter.
  # Again, we need a few things in the environment for the greeter to run with
  # fonts/icons.
  wrappedGtkGreeter = pkgs.runCommand "lightdm-gtk-greeter"
    { buildInputs = [ pkgs.makeWrapper ]; }
    ''
      # This wrapper ensures that we actually get themes
      makeWrapper ${pkgs.lightdm_gtk_greeter}/sbin/lightdm-gtk-greeter \
        $out/greeter \
        --prefix PATH : "${lib.getBin pkgs.stdenv.cc.libc}/bin" \
        --set GDK_PIXBUF_MODULE_FILE "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
        --set GTK_PATH "${theme}:${pkgs.gtk3.out}" \
        --set GTK_EXE_PREFIX "${theme}" \
        --set GTK_DATA_PREFIX "${theme}" \
        --set XDG_DATA_DIRS "${theme}/share:${icons}/share" \
        --set XDG_CONFIG_HOME "${theme}/share" \
        --set XCURSOR_PATH "${cursors}/share/icons"

      cat - > $out/lightdm-gtk-greeter.desktop << EOF
      [Desktop Entry]
      Name=LightDM Greeter
      Comment=This runs the LightDM Greeter
      Exec=$out/greeter
      Type=Application
      EOF
    '';

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
        description = ''
          Whether to enable lightdm-gtk-greeter as the lightdm greeter.
        '';
      };

      theme = {

        package = mkOption {
          type = types.package;
          default = pkgs.gnome3.gnome-themes-extra;
          defaultText = "pkgs.gnome3.gnome-themes-extra";
          description = ''
            The package path that contains the theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = ''
            Name of the theme to use for the lightdm-gtk-greeter.
          '';
        };

      };

      iconTheme = {

        package = mkOption {
          type = types.package;
          default = pkgs.gnome3.defaultIconTheme;
          defaultText = "pkgs.gnome3.defaultIconTheme";
          description = ''
            The package path that contains the icon theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = ''
            Name of the icon theme to use for the lightdm-gtk-greeter.
          '';
        };

      };

      cursorTheme = {

        package = mkOption {
          default = pkgs.gnome3.defaultIconTheme;
          defaultText = "pkgs.gnome3.defaultIconTheme";
          description = ''
            The package path that contains the cursor theme given in the name option.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "Adwaita";
          description = ''
            Name of the cursor theme to use for the lightdm-gtk-greeter.
          '';
        };

        size = mkOption {
          type = types.int;
          default = 16;
          description = ''
            Size of the cursor theme to use for the lightdm-gtk-greeter.
          '';
        };
      };

      clock-format = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "%F";
        description = ''
          Clock format string (as expected by strftime, e.g. "%H:%M")
          to use with the lightdm gtk greeter panel.

          If set to null the default clock format is used.
        '';
      };

      indicators = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = [ "~host" "~spacer" "~clock" "~spacer" "~session" "~language" "~a11y" "~power" ];
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration that should be put in the lightdm-gtk-greeter.conf
          configuration file.
        '';
      };

    };

  };

  config = mkIf (ldmcfg.enable && cfg.enable) {

    services.xserver.displayManager.lightdm.greeter = mkDefault {
      package = wrappedGtkGreeter;
      name = "lightdm-gtk-greeter";
    };

    environment.etc."lightdm/lightdm-gtk-greeter.conf".source = gtkGreeterConf;

  };
}
