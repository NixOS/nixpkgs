{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.led-matrix-monitoring;
  yamlFormat = pkgs.formats.yaml { };
  legacyMetricType = types.enum [
    "cpu"
    "net"
    "disk"
    "mem-bat"
    "none"
    "temp"
    "fan"
  ];

  appType = types.submodule (
    { ... }: {
      options = {
        name = mkOption {
          type = types.str;
          description = "App name as defined by the LED Matrix monitor (built-in or plugin app).";
          example = "cpu";
        };

        duration = mkOption {
          type = types.nullOr types.ints.positive;
          default = null;
          description = "Optional per-app duration in seconds. Falls back to layout duration when unset.";
        };

        animate = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to animate the app output.";
        };

        scope = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Optional app scope (for example `panel`).
            When set to `panel`, the active app owns the full panel and the sibling quadrant on that side is suppressed by the scheduler while it is active.
            If both top and bottom apps on a panel simultaneously request `scope = "panel"`, top quadrant takes precedence and a warning is logged.
          '';
        };

        persistentDraw = mkOption {
          type = types.bool;
          default = false;
          description = "Whether the app is responsible for continuously drawing during its active window.";
        };

        disposeFn = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional dispose function key for persistent-draw apps.";
        };

        display = mkOption {
          type = types.bool;
          default = true;
          description = "Whether this app should render pixels during its configured slice.";
        };

        args = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          description = "Optional app-specific arguments.";
        };
      };
    }
  );

  layoutType = types.submodule {
    options = {
      duration = mkOption {
        type = types.ints.positive;
        default = 10;
        description = "Default duration in seconds for app rotation.";
      };

      quadrants = mkOption {
        type = types.submodule {
          options = {
            topLeft = mkOption {
              type = types.listOf appType;
              default = [ ];
              description = "Apps displayed in the top-left quadrant, in rotation order.";
            };
            bottomLeft = mkOption {
              type = types.listOf appType;
              default = [ ];
              description = "Apps displayed in the bottom-left quadrant, in rotation order.";
            };
            topRight = mkOption {
              type = types.listOf appType;
              default = [ ];
              description = "Apps displayed in the top-right quadrant, in rotation order.";
            };
            bottomRight = mkOption {
              type = types.listOf appType;
              default = [ ];
              description = "Apps displayed in the bottom-right quadrant, in rotation order.";
            };
          };
        };
        default = { };
        description = "Quadrant-to-app mapping for the Nix-native layout.";
      };
    };
  };

  mapApp =
    app:
    {
      app = null;
      name = app.name;
      animate = app.animate;
    }
    // optionalAttrs (app.duration != null) { duration = app.duration; }
    // optionalAttrs (app.scope != null) { scope = app.scope; }
    // optionalAttrs app.persistentDraw { "persistent-draw" = true; }
    // optionalAttrs (app.disposeFn != null) { "dispose-fn" = app.disposeFn; }
    // optionalAttrs (!app.display) { display = false; }
    // optionalAttrs (app.args != { }) { args = app.args; };

  layoutAsSettings =
    if cfg.layout == null then
      null
    else
      {
        duration = cfg.layout.duration;
        quadrants = {
          top-left = map mapApp cfg.layout.quadrants.topLeft;
          bottom-left = map mapApp cfg.layout.quadrants.bottomLeft;
          top-right = map mapApp cfg.layout.quadrants.topRight;
          bottom-right = map mapApp cfg.layout.quadrants.bottomRight;
        };
      };

  legacyOptionsUsed = any (value: value != null) [
    cfg.topLeft
    cfg.bottomLeft
    cfg.topRight
    cfg.bottomRight
  ];

  inlineSettings =
    if cfg.layout != null then
      layoutAsSettings
    else if cfg.settings != null then
      cfg.settings
    else
      cfg.config;

  legacySettings = {
    duration = cfg.legacyDuration;
    quadrants = {
      top-left = [
        {
          app = null;
          name = cfg.topLeft;
          duration = cfg.legacyDuration;
          animate = false;
        }
      ];
      top-right = [
        {
          app = null;
          name = cfg.topRight;
          duration = cfg.legacyDuration;
          animate = false;
        }
      ];
      bottom-left = [
        {
          app = null;
          name = cfg.bottomLeft;
          duration = cfg.legacyDuration;
          animate = false;
        }
      ];
      bottom-right = [
        {
          app = null;
          name = cfg.bottomRight;
          duration = cfg.legacyDuration;
          animate = false;
        }
      ];
    };
  };

  managedConfigFile =
    if cfg.configFile != null then
      cfg.configFile
    else if inlineSettings != null then
      yamlFormat.generate "led-matrix-config.yaml" inlineSettings
    else if legacyOptionsUsed then
      yamlFormat.generate "led-matrix-config.yaml" legacySettings
    else
      null;

  resolvedConfigFile = if cfg.configurationMode == "linuxOS" then null else managedConfigFile;

  layoutQuadrantsNonEmpty =
    if cfg.layout == null then
      true
    else
      all (apps: apps != [ ]) [
        cfg.layout.quadrants.topLeft
        cfg.layout.quadrants.bottomLeft
        cfg.layout.quadrants.topRight
        cfg.layout.quadrants.bottomRight
      ];

  serviceArgs =
    optionals (resolvedConfigFile != null) [
      "--config-file"
      (toString resolvedConfigFile)
    ]
    ++ optionals cfg.disableKeyListener [ "--no-key-listener" ]
    ++ optionals cfg.disablePlugins [ "--disable-plugins" ]
    ++ cfg.extraArguments;

  serviceCommand = escapeShellArgs ([ "${cfg.package}/bin/led-matrix-monitor" ] ++ serviceArgs);
in
{
  options.services.led-matrix-monitoring = {
    enable = mkEnableOption "Framework LED Matrix system monitoring service";

    configurationMode = mkOption {
      type = types.enum [
        "linuxOS"
        "nix-flake"
        "nix-module"
      ];
      default = "nix-module";
      description = ''
        Selects how the service resolves configuration:
        - `linuxOS`: do not provide Nix-managed config; the app uses its built-in Linux config lookup.
        - `nix-flake`: use Nix-managed config generated/provided through module options.
        - `nix-module`: same config behavior as `nix-flake`, intended for direct module-driven setup.
      '';
    };

    package = mkPackageOption pkgs "framework-led-matrix-monitor" { };

    layout = mkOption {
      type = types.nullOr layoutType;
      default = null;
      description = ''
        Nix-native service layout schema.
        This is the recommended configuration style for NixOS users because it keeps
        all app and quadrant definitions in module options and generates runtime config automatically.
      '';
      example = literalExpression ''
        {
          duration = 10;
          quadrants = {
            topLeft = [{ name = "cpu"; }];
            bottomLeft = [{ name = "mem-bat"; }];
            topRight = [{ name = "disk"; }];
            bottomRight = [{ name = "net"; }];
          };
        }
      '';
    };

    settings = mkOption {
      type = types.nullOr yamlFormat.type;
      default = null;
      description = ''
        Raw settings as a Nix attrset rendered to YAML.
        This is kept for compatibility; prefer `layout`.
        Mutually exclusive with `configFile`.
      '';
    };

    config = mkOption {
      type = types.nullOr yamlFormat.type;
      default = null;
      description = ''
        Deprecated alias for `settings`.
      '';
    };

    configFile = mkOption {
      type = types.nullOr (
        types.oneOf [
          types.path
          types.str
        ]
      );
      default = null;
      description = ''
        Path to an existing YAML configuration file to pass to `--config-file`.
        Mutually exclusive with `layout`, `settings`, `config`, and legacy quadrant options.
      '';
      example = "/etc/led-matrix/config.yaml";
    };

    topLeft = mkOption {
      type = types.nullOr legacyMetricType;
      default = null;
      description = ''
        Deprecated legacy shorthand for top-left quadrant app.
        Use `layout` or `configFile` instead.
      '';
    };

    bottomLeft = mkOption {
      type = types.nullOr legacyMetricType;
      default = null;
      description = ''
        Deprecated legacy shorthand for bottom-left quadrant app.
        Use `layout` or `configFile` instead.
      '';
    };

    topRight = mkOption {
      type = types.nullOr legacyMetricType;
      default = null;
      description = ''
        Deprecated legacy shorthand for top-right quadrant app.
        Use `layout` or `configFile` instead.
      '';
    };

    bottomRight = mkOption {
      type = types.nullOr legacyMetricType;
      default = null;
      description = ''
        Deprecated legacy shorthand for bottom-right quadrant app.
        Use `layout` or `configFile` instead.
      '';
    };

    legacyDuration = mkOption {
      type = types.ints.positive;
      default = 10;
      description = ''
        Duration (in seconds) used when generating config from legacy quadrant options.
      '';
    };

    disableKeyListener = mkOption {
      type = types.bool;
      default = false;
      description = "Disable keyboard shortcut listener.";
    };

    disablePlugins = mkOption {
      type = types.bool;
      default = false;
      description = "Disable loading plugin apps.";
    };

    user = mkOption {
      type = types.str;
      default = "root";
      description = "User account to run the service as.";
    };

    group = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Primary group for the service user.
        Defaults to `root` when `user = "root"`, otherwise `users`.
      '';
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Additional environment variables passed to the systemd service.
      '';
      example = {
        DISPLAY = ":0";
      };
    };

    extraArguments = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Additional CLI arguments appended to the service command.
      '';
      example = [ "--list-apps" ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings == null || cfg.config == null;
        message = "services.led-matrix-monitoring: `settings` and deprecated `config` cannot both be set.";
      }
      {
        assertion =
          cfg.layout == null
          || (cfg.settings == null && cfg.config == null && cfg.configFile == null && !legacyOptionsUsed);
        message = "services.led-matrix-monitoring: `layout` is mutually exclusive with `settings`, `config`, `configFile`, and legacy quadrant options.";
      }
      {
        assertion =
          cfg.configFile == null
          || (cfg.layout == null && cfg.settings == null && cfg.config == null && !legacyOptionsUsed);
        message = "services.led-matrix-monitoring: `configFile` is mutually exclusive with `layout`, `settings`, `config`, and legacy quadrant options.";
      }
      {
        assertion =
          !legacyOptionsUsed
          || all (value: value != null) [
            cfg.topLeft
            cfg.bottomLeft
            cfg.topRight
            cfg.bottomRight
          ];
        message = "services.led-matrix-monitoring: when using legacy quadrant options, all four of topLeft/bottomLeft/topRight/bottomRight must be set.";
      }
      {
        assertion = layoutQuadrantsNonEmpty;
        message = "services.led-matrix-monitoring: each `layout.quadrants` entry must contain at least one app.";
      }
      {
        assertion = cfg.configurationMode != "linuxOS" || managedConfigFile == null;
        message = "services.led-matrix-monitoring: `configurationMode = \"linuxOS\"` cannot be combined with `layout`, `settings`, `config`, `configFile`, or legacy quadrant options.";
      }
      {
        assertion = cfg.configurationMode == "linuxOS" || managedConfigFile != null;
        message = "services.led-matrix-monitoring: for `nix-flake`/`nix-module`, set one configuration source (`layout`, `settings`, `config`, `configFile`, or all legacy quadrant options).";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.led-matrix-monitoring = {
      description = "Framework LED Matrix System Monitor";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment =
        cfg.environment
        // optionalAttrs (resolvedConfigFile != null) { CONFIG_FILE = toString resolvedConfigFile; }
        // {
          LED_MATRIX_CONFIGURATION_MODE = cfg.configurationMode;
        };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group =
          if cfg.group != null then
            cfg.group
          else if cfg.user == "root" then
            "root"
          else
            "users";
        SupplementaryGroups = optionals (!cfg.disableKeyListener && cfg.user != "root") [ "input" ];
        Restart = "always";
        RestartSec = "10s";
      };

      script = ''
        exec ${serviceCommand}
      '';
    };
  };

  meta.maintainers = with maintainers; [ timoteuszelle ];
}
