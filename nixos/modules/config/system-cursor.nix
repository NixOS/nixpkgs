{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.environment.pointerCursor;

  inherit (lib)
    mkEnableOption
    mkOption
    mkDefault
    mkIf
    types
    literalExpression
    ;
in
{
  options.environment.pointerCursor = {
    enable = mkEnableOption ''
      cursor config generation.

      Top-level options declared under this this module are backend independent
      options. Options declared under namespaces such as ‘gdm’ are backend
      specific options. You can disable configurations for specific backends via
      their ‘enable’ option. For example, set
      [](#opt-environment.pointerCursor.gdm.enable) to ‘false’ to disable GDM
      cursor configurations.

      To apply the configurations, the relevant subsytems must also be
      configured. For example, [](#opt-services.displayManager.gdm.enable) needs
      to be set in order for [](#opt-environment.pointerCursor.gdm.enable) to
      apply GDM cursor configuration'';

    package = mkOption {
      type = types.package;
      example = literalExpression "pkgs.vanilla-dmz";
      description = "Package providing the cursor theme.";
    };

    name = mkOption {
      type = types.str;
      example = "Vanilla-DMZ";
      description = "The cursor name within the package.";
    };

    size = mkOption {
      type = types.int;
      default = 32;
      example = 64;
      description = "The cursor size.";
    };

    gdm.enable = mkEnableOption "GDM config generation for {option}`environment.pointerCursor`" // {
      default = true;
    };

    sddm.enable = mkEnableOption "SDDM config generation for {option}`environment.pointerCursor`" // {
      default = true;
    };

    lightdm.greeters = {
      gtk.enable =
        mkEnableOption "LightDM GTK Greeter config generation for {option}`environment.pointerCursor`"
        // {
          default = true;
        };

      slick.enable =
        mkEnableOption "Slick-Greeter config generation for {option}`environment.pointerCursor`"
        // {
          default = true;
        };
    };

    dms-greeter.enable =
      mkEnableOption "DankMaterialShell greeter config generation for {option}`environment.pointerCursor`"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.sessionVariables = {
      XCURSOR_THEME = mkDefault cfg.name;
      XCURSOR_SIZE = mkDefault cfg.size;
      # Set directory to look for cursors in, needed for some applications
      # that are unable to find cursors otherwise. See:
      # https://github.com/nix-community/home-manager/issues/2812
      # https://wiki.archlinux.org/title/Cursor_themes#Environment_variable
      XCURSOR_PATH = [ "/run/current-system/sw/share/icons" ];
    };

    programs.dconf.profiles.gdm.databases =
      mkIf (config.services.displayManager.gdm.enable && cfg.gdm.enable)
        [
          {
            settings."org/gnome/desktop/interface" = {
              cursor-theme = cfg.name;
              cursor-size = lib.gvariant.mkInt32 cfg.size;
            };
          }
        ];

    services.displayManager.sddm.settings =
      mkIf (config.services.displayManager.sddm.enable && cfg.sddm.enable)
        {
          Theme = {
            CursorTheme = cfg.name;
            CursorSize = cfg.size;
          };
        };

    services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme =
      mkIf
        (
          config.services.xserver.displayManager.lightdm.enable
          && config.services.xserver.displayManager.lightdm.greeters.gtk.enable
          && cfg.lightdm.greeters.gtk.enable
        )
        {
          inherit (cfg) package name size;
        };

    services.xserver.displayManager.lightdm.greeters.slick.cursorTheme =
      mkIf
        (
          config.services.xserver.displayManager.lightdm.enable
          && config.services.xserver.displayManager.lightdm.greeters.slick.enable
          && cfg.lightdm.greeters.gtk.enable
        )
        {
          inherit (cfg) package name size;
        };

    services.displayManager.dms-greeter.compositor.customConfig =
      mkIf (config.services.displayManager.dms-greeter.enable && cfg.dms-greeter.enable)
        ''
          include "${pkgs.writeText "dms-greeter-cursor-config.kdl" ''
            cursor {
                xcursor-theme "${cfg.name}"
                xcursor-size ${toString cfg.size}
            }
          ''}"
        '';
  };
}
