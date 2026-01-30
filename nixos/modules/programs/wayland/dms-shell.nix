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
    mapAttrs
    mapAttrs'
    filterAttrs
    ;

  cfg = config.programs.dms-shell;

  path = [
    "programs"
    "dms-shell"
  ];

  builtInRemovedMsg = "This is now built-in in DMS and doesn't need additional dependencies.";

  optionalPackages =
    optionals cfg.enableSystemMonitoring [ pkgs.dgop ]
    ++ optionals cfg.enableVPN [
      pkgs.glib
      pkgs.networkmanager
    ]
    ++ optional cfg.enableDynamicTheming pkgs.matugen
    ++ optional cfg.enableAudioWavelength pkgs.cava
    ++ optional cfg.enableCalendarEvents pkgs.khal
    ++ optional cfg.enableClipboardPaste pkgs.wtype;
in
{
  imports = [
    (lib.mkRemovedOptionModule (path ++ [ "enableBrightnessControl" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (path ++ [ "enableColorPicker" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (
      path ++ [ "enableSystemSound" ]
    ) "qtmultimedia is now included on dms-shell package.")
    (lib.mkRemovedOptionModule (path ++ [ "enableClipboard" ]) builtInRemovedMsg)
  ];

  options.programs.dms-shell = {
    enable = mkEnableOption "DankMaterialShell, a complete desktop shell for Wayland compositors";

    package = mkPackageOption pkgs "dms-shell" { };

    systemd = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable DankMaterialShell systemd startup service.
        '';
      };

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

    enableVPN = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for VPN widgets.
        This enables VPN status monitoring and management through NetworkManager.

        Requires: glib, networkmanager
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

    enableClipboardPaste = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install dependencies required for pasting directly from the clipboard history support.
        This enables pressing Shift+Return for pasting entries from the clipboard history.

        Requires: wtype
      '';
    };

    quickshell = {
      package = mkPackageOption pkgs "quickshell" { };
    };

    plugins = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Whether to enable this plugin";
            };
            src = mkOption {
              type = types.either types.package types.path;
              description = "Source of the plugin package or path";
            };
          };
        }
      );
      default = { };
      description = "DMS Plugins to install and enable";
      example = lib.literalExpression ''
        {
          DockerManager = {
            src = pkgs.fetchFromGitHub {
              owner = "LuckShiba";
              repo = "DmsDockerManager";
              rev = "v1.2.0";
              sha256 = "sha256-VoJCaygWnKpv0s0pqTOmzZnPM922qPDMHk4EPcgVnaU=";
            };
          };
          AnotherPlugin = {
            enable = true;
            src = pkgs.another-plugin;
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = lib.mkIf cfg.systemd.enable [ cfg.package ];

    systemd.user.services.dms = lib.mkIf cfg.systemd.enable {
      wantedBy = [ cfg.systemd.target ];
      restartIfChanged = cfg.systemd.restartIfChanged;
      path = lib.mkForce [ ];
    };

    environment.systemPackages = [
      cfg.package
      cfg.quickshell.package
    ]
    ++ optionalPackages;

    environment.etc =
      mapAttrs'
        (name: value: {
          name = "xdg/quickshell/dms-plugins/${name}";
          inherit value;
        })
        (
          mapAttrs (name: plugin: {
            source = plugin.src;
          }) (filterAttrs (n: v: v.enable) cfg.plugins)
        );

    services.power-profiles-daemon.enable = lib.mkDefault true;
    services.accounts-daemon.enable = lib.mkDefault true;
    hardware.i2c.enable = lib.mkDefault true;
    hardware.graphics.enable = lib.mkDefault true;
  };

  meta.maintainers = lib.teams.danklinux.members;
}
