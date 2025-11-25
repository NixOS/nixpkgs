{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    types
    optional
    optionals
    ;

  cfg = config.programs.dms-shell;

  optionalPackages =
    optionals cfg.enableSystemMonitoring [ pkgs.dgop ]
    ++ optionals cfg.enableClipboard [
      pkgs.cliphist
      pkgs.wl-clipboard
    ]
    ++ optionals cfg.enableVPN [
      pkgs.glib
      pkgs.networkmanager
    ]
    ++ optional cfg.enableBrightnessControl pkgs.brightnessctl
    ++ optional cfg.enableColorPicker pkgs.hyprpicker
    ++ optional cfg.enableDynamicTheming pkgs.matugen
    ++ optional cfg.enableAudioWavelength pkgs.cava
    ++ optional cfg.enableCalendarEvents pkgs.khal
    ++ optional cfg.enableSystemSound pkgs.kdePackages.qtmultimedia;
in
{
  options.programs.dms-shell = {
    enable = mkEnableOption "DankMaterialShell, a complete desktop shell for Wayland compositors";

    package = mkPackageOption pkgs "dms-shell" { };

    systemd = {
      target = mkOption {
        type = types.str;
        default = "graphical-session.target";
        description = ''
          The systemd target that will automatically start the DankMaterialShell service.

          Common targets include:
          - `graphical-session.target` for most desktop environments
          - `wayland-session.target` for Wayland-specific sessions
        '';
      };

      restartIfChanged = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to restart the dms.service when the DankMaterialShell package or
          configuration changes. This ensures the latest version is always running
          after a system rebuild.
        '';
      };
    };

    enableSystemMonitoring = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for system monitoring widgets.
        This includes process list viewers and system resource monitors.

        Requires: dgop
      '';
    };

    enableClipboard = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for clipboard management widgets.
        This enables clipboard history and clipboard manager functionality.

        Requires: cliphist, wl-clipboard
      '';
    };

    enableVPN = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for VPN widgets.
        This enables VPN status monitoring and management through NetworkManager.

        Requires: glib, networkmanager
      '';
    };

    enableBrightnessControl = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for brightness and backlight control.
        This enables screen brightness adjustment widgets.

        Requires: brightnessctl
      '';
    };

    enableColorPicker = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for color picking functionality.
        This enables on-screen color picker tools.

        Requires: hyprpicker
      '';
    };

    enableDynamicTheming = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for dynamic theming support.
        This enables automatic theme generation based on wallpapers and other sources.

        Requires: matugen
      '';
    };

    enableAudioWavelength = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for audio wavelength visualization.
        This enables audio spectrum and waveform visualizer widgets.

        Requires: cava
      '';
    };

    enableCalendarEvents = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for calendar events support.
        This enables calendar widgets that display events and reminders via khal.

        Requires: khal
      '';
    };

    enableSystemSound = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for system sound support.
        This enables audio playback for system notifications and events.

        Requires: qtmultimedia
      '';
    };

    quickshell = {
      package = mkPackageOption pkgs "quickshell" { };
    };
  };

  config = mkIf cfg.enable {
    environment.etc."xdg/quickshell/dms".source = "${cfg.package}/share/quickshell/dms";

    systemd.packages = [ cfg.package ];

    systemd.user.services.dms = {
      wantedBy = [ cfg.systemd.target ];
      restartTriggers = optional cfg.systemd.restartIfChanged "${cfg.package}/share/quickshell/dms";
      path = lib.mkForce [ ];
    };

    environment.systemPackages = [
      cfg.package
      cfg.quickshell.package
      pkgs.ddcutil
      pkgs.libsForQt5.qt5ct
      pkgs.kdePackages.qt6ct
    ]
    ++ optionalPackages;

    fonts.packages = with pkgs; [
      fira-code
      inter
      material-symbols
    ];

    hardware.graphics.enable = lib.mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ luckshiba ];
}
