{ config, lib, pkgs, ... }:

with lib;
let
  dmcfg = config.services.xserver.displayManager;
  ldmcfg = dmcfg.lightdm;
  cfg = ldmcfg.greeters.enso;

  theme = cfg.theme.package;
  icons = cfg.iconTheme.package;
  cursors = cfg.cursorTheme.package;

  # We need a few things in the environment for the greeter to run with
  # fonts/icons.
  wrappedEnsoGreeter = pkgs.runCommand "lightdm-enso-os-greeter" {
      buildInputs = [ pkgs.makeWrapper ];
      preferLocalBuild = true;
    } ''
      # This wrapper ensures that we actually get themes
      makeWrapper ${pkgs.lightdm-enso-os-greeter}/bin/pantheon-greeter \
        $out/greeter \
        --prefix PATH : "${pkgs.glibc.bin}/bin" \
        --set GDK_PIXBUF_MODULE_FILE "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
        --set GTK_PATH "${theme}:${pkgs.gtk3.out}" \
        --set GTK_EXE_PREFIX "${theme}" \
        --set GTK_DATA_PREFIX "${theme}" \
        --set XDG_DATA_DIRS "${theme}/share:${icons}/share:${cursors}/share" \
        --set XDG_CONFIG_HOME "${theme}/share"

      cat - > $out/lightdm-enso-os-greeter.desktop << EOF
      [Desktop Entry]
      Name=LightDM Greeter
      Comment=This runs the LightDM Greeter
      Exec=$out/greeter
      Type=Application
      EOF
    '';

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
in {
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
            Name of the theme to use for the lightdm-enso-os-greeter
          '';
        };
      };

      iconTheme = {
        package = mkOption {
          type = types.package;
          default = pkgs.papirus-icon-theme;
          defaultText = "pkgs.papirus-icon-theme";
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
          defaultText = "pkgs.capitaine-cursors";
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

    services.xserver.displayManager.lightdm = {
      greeter = mkDefault {
        package = wrappedEnsoGreeter;
        name = "lightdm-enso-os-greeter";
      };

      greeters = {
        gtk = {
          enable = mkDefault false;
        };
      };
    };
  };
}
