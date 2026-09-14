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

in
{
  imports = [
    (lib.mkRemovedOptionModule (path ++ [ "enableBrightnessControl" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (path ++ [ "enableColorPicker" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (
      path ++ [ "enableSystemSound" ]
    ) "qtmultimedia is now included on dms-shell package.")
    (lib.mkRemovedOptionModule (path ++ [ "enableClipboard" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (path ++ [ "enableSystemMonitoring" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (path ++ [ "enableClipboardPaste" ]) builtInRemovedMsg)
    (lib.mkRemovedOptionModule (path ++ [ "enableVPN" ])
      "Networking backends are detected by DMS at runtime. Configure the desired networking service separately."
    )
    (lib.mkRemovedOptionModule (
      path ++ [ "enableDynamicTheming" ]
    ) "Install matugen separately to use DMS dynamic theming.")
    (lib.mkRemovedOptionModule (
      path ++ [ "enableAudioWavelength" ]
    ) "Install cava separately to use the DMS audio visualizer.")
    (lib.mkRemovedOptionModule (
      path ++ [ "enableCalendarEvents" ]
    ) "Install a supported calendar backend separately and select it in DMS settings.")
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
    ];

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

  meta.teams = [ lib.teams.danklinux ];
}
