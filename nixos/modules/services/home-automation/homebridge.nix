{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.homebridge;

  restartCommand = "sudo -n systemctl restart homebridge homebridge-config-ui-x";
  homebridgePackagePath = "${pkgs.homebridge}/lib/node_modules/homebridge";

  defaultConfigUIPlatform = {
    inherit (cfg.uiSettings)
      platform
      name
      port
      standalone
      restart
      homebridgePackagePath
      sudo
      log
      ;
  };

  defaultConfig = {
    description = "Homebridge";
    bridge = {
      inherit (cfg.settings.bridge) name port;
      # These have to be set at least once, otherwise the homebridge will not work
      username = "CC:22:3D:E3:CE:30";
      pin = "031-45-154";
    };
    platforms = [
      defaultConfigUIPlatform
    ];
  };

  defaultConfigFile = settingsFormat.generate "config.json" defaultConfig;

  nixOverrideConfig = cfg.settings // {
    platforms = [ cfg.uiSettings ] ++ cfg.settings.platforms;
  };

  nixOverrideConfigFile = settingsFormat.generate "nixOverrideConfig.json" nixOverrideConfig;

  # Create a single jq filter that updates all fields at once
  # Platforms need to be unique by "platform"
  # Accessories need to be unique by "name"
  jqMergeFilter = ''
    reduce .[] as $item (
      {};
      . * $item + {
        "platforms": (
          ((.platforms // []) + ($item.platforms // [])) |
          group_by(.platform) |
          map(reduce .[] as $platform ({}; . * $platform))
        ),
        "accessories": (
          ((.accessories // []) + ($item.accessories // [])) |
          group_by(.name) |
          map(reduce .[] as $accessory ({}; . * $accessory))
        )
      }
    )
  '';

  jqMergeFilterFile = pkgs.writeTextFile {
    name = "jqMergeFilter.jq";
    text = jqMergeFilter;
  };

  # Validation function to ensure no platform has the platform "config".
  # We want to make sure settings for the "config" platform are set in uiSettings.
  validatePlatforms =
    platforms:
    let
      conflictingPlatforms = builtins.filter (p: p.platform == "config") platforms;
    in
    if builtins.length conflictingPlatforms > 0 then
      throw "The platforms list must not contain any platform with platform type 'config'.  Use the uiSettings attribute instead."
    else
      platforms;

  settingsFormat = pkgs.formats.json { };
in
{
  options.services.homebridge = with types; {

    # Basic Example
    # {
    #   services.homebridge = {
    #     enable = true;
    #     # Necessary for service to be reachable
    #     openFirewall = true;
    #     # Most accessories need unauthenticated access
    #     allowInsecure = true;
    #   };
    # }

    enable = mkEnableOption "Homebridge: Homekit home automation";

    user = mkOption {
      type = str;
      default = "homebridge";
      description = "User to run homebridge as.";
    };

    group = mkOption {
      type = str;
      default = "homebridge";
      description = "Group to run homebridge as.";
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Open ports in the firewall for the Homebridge web interface and service.
      '';
    };

    allowInsecure = mkOption {
      type = bool;
      default = false;
      description = ''
        Allow unauthenticated requests (for easier hacking).
        In homebridge's own installer, this is enabled by default.
        Needs to be enabled if you want to control accessories:
        https://github.com/homebridge/homebridge-config-ui-x/wiki/Enabling-Accessory-Control
      '';
    };

    userStoragePath = mkOption {
      type = str;
      default = "/var/lib/homebridge";
      description = ''
        Path to store homebridge user files (needs to be writeable).
      '';
    };

    pluginPath = mkOption {
      type = str;
      default = "/var/lib/homebridge/node_modules";
      description = ''
        Path to the plugin download directory (needs to be writeable).
        Seems this needs to end with node_modules, as Homebridge will run npm
        on the parent directory.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to an environment-file which may contain secrets.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Configuration options for homebridge.

        For more details, see [the homebridge documentation](https://github.com/homebridge/homebridge/wiki/Homebridge-Config-JSON-Explained).
      '';
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          description = mkOption {
            type = str;
            default = "Homebridge";
            description = "Description of the homebridge instance.";
            readOnly = true;
          };

          bridge.name = mkOption {
            type = str;
            default = "Homebridge";
            description = "Name of the homebridge";
          };

          bridge.port = mkOption {
            type = port;
            default = 51826;
            description = "The port homebridge listens on";
          };

          platforms = mkOption {
            description = "Homebridge Platforms";
            default = [ ];
            apply = validatePlatforms;
            type = listOf (submodule {
              freeformType = settingsFormat.type;
              options = {
                name = mkOption {
                  type = str;
                  description = "Name of the platform";
                };
                platform = mkOption {
                  type = str;
                  description = "Platform type";
                };
              };
            });
          };

          accessories = mkOption {
            description = "Homebridge Accessories";
            default = [ ];
            type = listOf (submodule {
              freeformType = settingsFormat.type;
              options = {
                name = mkOption {
                  type = str;
                  description = "Name of the accessory";
                };
                accessory = mkOption {
                  type = str;
                  description = "Accessory type";
                };
              };
            });
          };
        };
      };
    };

    # Defines the parameters for the Homebridge UI Plugin.
    # This submodule will get merged into the "platforms" array
    # inside settings.
    uiSettings = mkOption {
      # Full list of UI settings can be found here: https://github.com/homebridge/homebridge-config-ui-x/wiki/Config-Options
      default = { };
      description = ''
        Configuration options for homebridge config UI plugin.

        For more details, see [the homebridge-config-ui-x documentation](https://github.com/homebridge/homebridge-config-ui-x/wiki/Config-Options).
      '';
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          ## Following parameters must be set, and can't be changed.

          # Must be "config" for UI service to see its config
          platform = mkOption {
            type = str;
            default = "config";
            description = "Type of the homebridge UI platform";
            readOnly = true;
          };

          name = mkOption {
            type = str;
            default = "Config";
            description = "Name of the homebridge UI platform";
            readOnly = true;
          };

          # Required to be true to run Homebridge UI as a separate service
          standalone = mkOption {
            type = bool;
            default = true;
            description = "Whether to run the UI as a standalone service";
            readOnly = true;
          };

          # Homebridge can be installed many ways, but we're forcing a double service systemd setup
          # This command will restart both services
          restart = mkOption {
            type = str;
            default = restartCommand;
            description = "Command to restart the homebridge UI service";
            readOnly = true;
          };

          # Tell Homebridge UI where homebridge is so it can pull package information
          homebridgePackagePath = mkOption {
            type = str;
            default = homebridgePackagePath;
            defaultText = "/path/to/homebridge";
            description = "Path to the homebridge package";
            readOnly = true;
          };

          # If sudo is true, homebridge will download plugins as root
          sudo = mkOption {
            type = bool;
            default = false;
            description = "Whether to run the UI with sudo";
            readOnly = true;
          };

          # We're using systemd, so make sure logs is setup to pull from systemd
          log.method = mkOption {
            type = str;
            default = "systemd";
            description = "Method to use for logging";
            readOnly = true;
          };

          log.service = mkOption {
            type = str;
            default = "homebridge";
            description = "Name of the systemd service to log to";
            readOnly = true;
          };

          # The following options are allowed to be changed.
          port = mkOption {
            type = port;
            default = 8581;
            description = "The port the UI web service should listen on";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.homebridge = {
      description = "Homebridge";
      wants = [ "network-online.target" ];
      after = [
        "syslog.target"
        "network-online.target"
      ];
      wantedBy = [ "multi-user.target" ];

      # On start, if the config file is missing, create a default one
      # Otherwise, ensure that the config file is using the
      # properties as specified by nix.
      # Not sure if there is a better way to do this than to use jq
      # to replace sections of json.
      preStart = ''
        # If the user storage path does not exist, create it
        if [ ! -d "${cfg.userStoragePath}" ]; then
          install -d -m 700 -o ${cfg.user} -g ${cfg.group} "${cfg.userStoragePath}"
        fi
        # If there is no config file, create a placeholder default
        if [ ! -e "${cfg.userStoragePath}/config.json" ]; then
          install -D -m 600 -o ${cfg.user} -g ${cfg.group} "${defaultConfigFile}" "${cfg.userStoragePath}/config.json"
        fi

        # Apply all nix override settings to config.json in a single jq operation
        ${pkgs.jq}/bin/jq -s -f "${jqMergeFilterFile}" "${cfg.userStoragePath}/config.json" "${nixOverrideConfigFile}" | ${pkgs.jq}/bin/jq . > "${cfg.userStoragePath}/config.json.tmp"
        install -D -m 600 -o ${cfg.user} -g ${cfg.group} "${cfg.userStoragePath}/config.json.tmp" "${cfg.userStoragePath}/config.json"

        # Remove temporary files
        rm "${cfg.userStoragePath}/config.json.tmp"

        # Make sure plugin directory exists
        install -d -m 755 -o ${cfg.user} -g ${cfg.group} "${cfg.pluginPath}"
      '';

      # Settings found from standalone mode docs and hb-service code
      # https://github.com/homebridge/homebridge-config-ui-x/wiki/Standalone-Mode
      # https://github.com/homebridge/homebridge-config-ui-x/blob/a12ad881fe6df62d817ecb56f9fc6b7e82b6d078/src/bin/platforms/linux.ts#L714
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        PermissionsStartOnly = true;
        StateDirectory = "homebridge";
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart =
          "${pkgs.homebridge}/bin/homebridge -U ${cfg.userStoragePath} -P ${cfg.pluginPath} --strict-plugin-resolution"
          + optionalString cfg.allowInsecure " -I";
        Restart = "always";
        RestartSec = 3;
        KillMode = "process";
        CapabilityBoundingSet = [
          "CAP_IPC_LOCK"
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_CHROOT"
          "CAP_CHOWN"
          "CAP_FOWNER"
          "CAP_DAC_OVERRIDE"
          "CAP_AUDIT_WRITE"
          "CAP_SYS_ADMIN"
        ];
        AmbientCapabilities = [
          "CAP_NET_RAW"
          "CAP_NET_BIND_SERVICE"
        ];
      };
    };

    systemd.services.homebridge-config-ui-x = {
      description = "Homebridge Config UI X";
      wants = [ "network-online.target" ];
      after = [
        "syslog.target"
        "network-online.target"
        "homebridge.service"
      ];
      requires = [ "homebridge.service" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        # Tools listed in homebridge's installation documentations:
        # https://github.com/homebridge/homebridge/wiki/Install-Homebridge-on-Arch-Linux
        nodejs_22
        nettools
        gcc
        gnumake
        # Required for access to systemctl and journalctl
        systemd
        # Required for access to sudo
        "/run/wrappers"
        # Some plugins need bash to download tools
        bash
      ];

      environment = {
        HOMEBRIDGE_CONFIG_UI_TERMINAL = "1";
        DISABLE_OPENCOLLECTIVE = "true";
        # Required or homebridge will search the global npm namespace
        UIX_STRICT_PLUGIN_RESOLUTION = "1";
      };

      # Settings found from standalone mode docs and hb-service code
      # https://github.com/homebridge/homebridge-config-ui-x/wiki/Standalone-Mode
      # https://github.com/homebridge/homebridge-config-ui-x/blob/a12ad881fe6df62d817ecb56f9fc6b7e82b6d078/src/bin/platforms/linux.ts#L714
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        PermissionsStartOnly = true;
        StateDirectory = "homebridge";
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart =
          "${pkgs.homebridge-config-ui-x}/bin/homebridge-config-ui-x -U ${cfg.userStoragePath} -P ${cfg.pluginPath}"
          + optionalString cfg.allowInsecure " -I";
        Restart = "always";
        RestartSec = 3;
        KillMode = "process";
        CapabilityBoundingSet = [
          "CAP_IPC_LOCK"
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_CHROOT"
          "CAP_CHOWN"
          "CAP_FOWNER"
          "CAP_DAC_OVERRIDE"
          "CAP_AUDIT_WRITE"
          "CAP_SYS_ADMIN"
        ];
        AmbientCapabilities = [
          "CAP_NET_RAW"
          "CAP_NET_BIND_SERVICE"
        ];
      };
    };

    # Create a user whose home folder is the user storage path
    users.users = lib.mkIf (cfg.user == "homebridge") {
      homebridge = {
        inherit (cfg) group;
        # Necessary so that this user can run journalctl
        extraGroups = [ "systemd-journal" ];
        description = "homebridge user";
        isSystemUser = true;
        home = cfg.userStoragePath;
      };
    };

    users.groups = lib.mkIf (cfg.group == "homebridge") {
      homebridge = { };
    };

    # Need passwordless sudo for a few commands
    # homebridge-config-ui-x needs for some features
    security.sudo.extraRules = [
      {
        users = [ cfg.user ];
        commands = [
          {
            # Ability to restart homebridge services
            command = "${pkgs.systemd}/bin/systemctl restart homebridge homebridge-config-ui-x";
            options = [ "NOPASSWD" ];
          }
          {
            # Ability to shutdown server
            command = "${pkgs.systemd}/bin/shutdown -h now";
            options = [ "NOPASSWD" ];
          }
          {
            # Ability to restart server
            command = "${pkgs.systemd}/bin/shutdown -r now";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    networking.firewall = {
      allowedTCPPorts = mkIf cfg.openFirewall [
        cfg.settings.bridge.port
        cfg.uiSettings.port
      ];
      allowedUDPPorts = mkIf cfg.openFirewall [ 5353 ];
    };
  };
}
