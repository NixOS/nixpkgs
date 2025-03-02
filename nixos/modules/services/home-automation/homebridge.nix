{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.homebridge;

  args = concatStringsSep " " (
    [
      "-U ${cfg.userStoragePath}"
      "-P ${cfg.pluginPath}"
      "--strict-plugin-resolution"
    ]
    ++ optionals cfg.allowInsecure [ "-I" ]
  );

  restartCommand = "sudo -n systemctl restart homebridge homebridge-config-ui-x";
  homebridgePackagePath = "${pkgs.homebridge}/lib/node_modules/homebridge";

  defaultConfigPlatform =
    {
      platform = "config";
      name = "Config";
      inherit (cfg.ui) port;
      # Required to be true to run Homebridge UI as a separate service
      standalone = true;
      # Homebridge can be installed many ways, but we're forcing a double service systemd setup
      restart = restartCommand;
      # Tell Homebridge UI where homebridge is so it can pull package information
      inherit homebridgePackagePath;
      # If sudo is true, homebridge will download plugins as root
      sudo = false;
      # We're using systemd, so make sure logs is setup to pull from systemd
      log = {
        method = "systemd";
        service = "homebridge";
      };
    }
    // optionalAttrs (cfg.ui.host != null) {
      inherit (cfg.ui) host;
    }
    // optionalAttrs (cfg.ui.proxyHost != null) {
      inherit (cfg.ui) proxyHost;
    }
    // optionalAttrs (cfg.ui.auth != null) {
      inherit (cfg.ui) auth;
    }
    // optionalAttrs (cfg.ui.sessionTimeout != null) {
      inherit (cfg.ui) sessionTimeout;
    }
    // optionalAttrs (cfg.ui.ssl != null) {
      ssl = {
        inherit (cfg.ui.ssl)
          key
          cert
          pfx
          passphrase
          ;
      };
    }
    // optionalAttrs (cfg.ui.tempUnits != null) {
      inherit (cfg.ui) tempUnits;
    }
    // optionalAttrs (cfg.ui.theme != null) {
      inherit (cfg.ui) theme;
    }
    // optionalAttrs (cfg.ui.lang != null) {
      inherit (cfg.ui) lang;
    }
    // optionalAttrs (cfg.ui.loginWallpaper != null) {
      inherit (cfg.ui) loginWallpaper;
    }
    // optionalAttrs (cfg.ui.scheduledBackupDisable != null) {
      inherit (cfg.ui) scheduledBackupDisable;
    }
    // optionalAttrs (cfg.ui.scheduledBackupPath != null) {
      inherit (cfg.ui) scheduledBackupPath;
    }
    // optionalAttrs (cfg.ui.debug != null) {
      inherit (cfg.ui) debug;
    }
    // optionalAttrs (cfg.ui.disableServerMetricsMonitoring != null) {
      inherit (cfg.ui) disableServerMetricsMonitoring;
    };

  defaultConfig = {
    description = "Homebridge";
    bridge =
      {
        inherit (cfg.bridge) name port;
        username = if (cfg.bridge.username != null) then cfg.bridge.username else "CC:22:3D:E3:CE:30";
        pin = if (cfg.bridge.pin != null) then cfg.bridge.pin else "031-45-154";
      }
      // optionalAttrs (cfg.bridge.advertiser != null) {
        inherit (cfg.bridge) advertiser;
      }
      // optionalAttrs (cfg.bridge.bind != null) {
        inherit (cfg.bridge) bind;
      }
      // optionalAttrs (cfg.bridge.setupID != null) {
        inherit (cfg.bridge) setupID;
      }
      // optionalAttrs (cfg.bridge.manufacturer != null) {
        inherit (cfg.bridge) manufacturer;
      }
      // optionalAttrs (cfg.bridge.model != null) {
        inherit (cfg.bridge) model;
      }
      // optionalAttrs (cfg.bridge.disableIpc != null) {
        inherit (cfg.bridge) disableIpc;
      };
    platforms = [
      defaultConfigPlatform
    ];
  };

  defaultConfigFile = pkgs.writeTextFile {
    name = "config.json";
    text = builtins.toJSON defaultConfig;
  };
in
{
  options.services.homebridge = with types; {
    enable = mkEnableOption "Homebridge: Homekit home automation";

    bridge = mkOption {
      description = "Homebridge Bridge options";
      default = { };
      example = {
        enable = true;
        openFirewall = true;
        allowInsecure = true;
      };
      type = submodule {
        options = {
          name = mkOption {
            type = str;
            default = "Homebridge";
            description = ''
              Name of the homebridge.
            '';
          };

          port = mkOption {
            type = port;
            default = 51826;
            description = ''
              The port homebridge listens on.
            '';
          };

          username = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The username for the homebridge service.
            '';
          };

          pin = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The pin for the homebridge service.
            '';
          };

          advertiser = mkOption {
            type = nullOr (enum [
              "ciao"
              "bonjour-hap"
              "avahi"
              "resolved"
            ]);
            default = null;
            description = ''
              Which mDNS advertiser homebridge should use.
              Accepts "ciao", "bonjour-hap", "avahi", or "resolved".
            '';
          };

          bind = mkOption {
            type = nullOr (listOf str);
            default = null;
            description = ''
              The network interfaces Homebridge should advertise / listen from
              Accepts an array of network interface names or IP addresses
            '';
          };

          setupID = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The setup ID for the homebridge service.
            '';
          };

          manufacturer = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The manufacturer of the homebridge device.
            '';
          };

          model = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The model of the homebridge device.
            '';
          };

          disableIpc = mkOption {
            type = nullOr bool;
            default = null;
            description = ''
              Disable the homebridge IPC service.
            '';
          };
        };
      };
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Open ports in the firewall for the Homebridge web interface.
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

    ui = mkOption {
      description = "Homebridge UI options";
      default = { };
      type = submodule {
        options = {
          port = mkOption {
            type = port;
            default = 8581;
            description = ''
              The port the UI web service should listen on.
            '';
          };

          host = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The IP address of the interface the UI should listen on.
              By default the UI will listen on all interfaces.
              In most cases this will be '::' or '0.0.0.0'
            '';
          };

          proxyHost = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The host and port "example.com:8080" you will be accessing the UI on.
              This is only required if you are accessing the UI behind a reverse proxy
              and are not passing through the host from the browser.
            '';
          };

          auth = mkOption {
            type = nullOr (enum [
              "form"
              "none"
            ]);
            default = null;
            description = ''
              The authentication method the UI should use.
              Accepts "form" or "none".
            '';
          };

          sessionTimeout = mkOption {
            type = nullOr int;
            default = null;
            description = ''
              The number of seconds a login session will last for. The default is equal to 8 hours.
            '';
          };

          ssl = mkOption {
            description = "Homebridge UI SSL options";
            default = null;
            type = nullOr (submodule {
              options = {
                key = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    Path To Private Key
                  '';
                };

                cert = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    Path To Certificate
                  '';
                };

                pfx = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    Path To PKCS#12 Certificate
                  '';
                };

                passphrase = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    PKCS#12 Certificate Passphrase
                  '';
                };
              };
            });
          };

          tempUnits = mkOption {
            type = nullOr (enum [
              "c"
              "f"
            ]);
            default = null;
            description = ''
              The temperature units that will be used in the UI.
              Accepts "c" or "f".
            '';
          };

          theme = mkOption {
            type = nullOr (enum [
              "auto"
              "red"
              "pink"
              "purple"
              "deep-purple"
              "indigo"
              "blue"
              "navi-blue"
              "blue-grey"
              "cyan"
              "green"
              "teal"
              "orange"
              "amber"
              "grey"
              "brown"
              "dark-mode"
              "dark-mode-red"
              "dark-mode-pink"
              "dark-mode-purple"
              "dark-mode-indigo"
              "dark-mode-blue"
              "dark-mode-blue-grey"
              "dark-mode-green"
              "dark-mode-grey"
              "dark-mode-brown"
              "dark-mode-teal"
              "dark-mode-cyan"
            ]);
            default = null;
            description = ''
              The color scheme / theme the user interface should use.
              Accepts "auto", "red", "pink", "purple", "deep-purple", "indigo", "blue", "navi-blue", "blue-grey", "cyan", "green", "teal", "orange", "amber", "grey", "brown", "dark-mode", "dark-mode-red", "dark-mode-pink", "dark-mode-purple", "dark-mode-indigo", "dark-mode-blue", "dark-mode-blue-grey", "dark-mode-green", "dark-mode-grey", "dark-mode-brown", "dark-mode-teal", or "dark-mode-cyan".
            '';
          };

          lang = mkOption {
            type = nullOr (enum [
              "bg"
              "ca"
              "cs"
              "de"
              "en"
              "es"
              "fr"
              "he"
              "hu"
              "id"
              "it"
              "ja"
              "ko"
              "mk"
              "nl"
              "no"
              "pl"
              "pt-BR"
              "pt"
              "ru"
              "sl"
              "sv"
              "th"
              "tr"
              "uk"
              "zh-CN"
              "zh-TW"
            ]);
            default = null;
            description = ''
              Set the Language the UI should use. If not set the browser's lanugage settings will be used instead.
              Accepts "bg", "ca", "cs", "de", "en", "es", "fr", "he", "hu", "id", "it", "ja", "ko", "mk", "nl", "no", "pl", "pt-BR", "pt", "ru", "sl", "sv", "th", "tr", "uk", "zh-CN", or "zh-TW".
            '';
          };

          loginWallpaper = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The path to an image that should be used on the UI login page. If this is not defined the default login wallpaper will be used.
            '';
          };

          scheduledBackupDisable = mkOption {
            type = nullOr bool;
            default = null;
            description = ''
              Set to true to disable the daily scheduled backups.
            '';
          };

          scheduledBackupPath = mkOption {
            type = nullOr str;
            default = null;
            description = ''
              The full path to an existing directory where the automated daily backup archives
              should be saved. The "homebridge" user MUST have read / write access to this directory.
            '';
          };

          debug = mkOption {
            type = nullOr bool;
            default = null;
            description = ''
              Enable debug logging
            '';
          };

          disableServerMetricsMonitoring = mkOption {
            type = nullOr bool;
            default = null;
            description = ''
              When enabled, the Homebridge UI will not collect or report cpu / memory stats
            '';
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
      # Otherwise, make ensure that the config file is using the
      # properties as specified by nix.
      # Not sure if there is a better way to do this than to use jq
      # to replace sections of json.
      preStart = ''
        if [ ! -e "${cfg.userStoragePath}/config.json" ]; then
          cp --force "${defaultConfigFile}" "${cfg.userStoragePath}/config.json"
        else
          # Create a single jq filter that updates all fields at once
          jq_filter=$(cat <<EOF
            .bridge = (.bridge // {}) * {
              name: "${cfg.bridge.name}",
              port: ${toString cfg.bridge.port}
              ${optionalString (cfg.bridge.username != null) '',"username": "${cfg.bridge.username}"''}
              ${optionalString (cfg.bridge.pin != null) '',"pin": "${cfg.bridge.pin}"''}
              ${
                optionalString (cfg.bridge.advertiser != null) '',"advertiser": "${cfg.bridge.advertiser}"''
              }
              ${optionalString (cfg.bridge.bind != null) '',"bind": ${builtins.toJSON cfg.bridge.bind}''}
              ${optionalString (cfg.bridge.setupID != null) '',"setupID": "${cfg.bridge.setupID}"''}
              ${
                optionalString (cfg.bridge.manufacturer != null) '',"manufacturer": "${cfg.bridge.manufacturer}"''
              }
              ${optionalString (cfg.bridge.model != null) '',"model": "${cfg.bridge.model}"''}
              ${
                optionalString (cfg.bridge.disableIpc != null) '',"disableIpc": ${toString cfg.bridge.disableIpc}''
              }
            } |
            .platforms |= map(
              if .platform == "config" then
                . * {
                  port: ${toString cfg.ui.port},
                  standalone: true,
                  restart: "${restartCommand}",
                  homebridgePackagePath: "${homebridgePackagePath}",
                  sudo: false,
                  log: {
                    method: "systemd",
                    service: "homebridge"
                  }
                  ${optionalString (cfg.ui.host != null) '',"host": "${cfg.ui.host}"''}
                  ${optionalString (cfg.ui.proxyHost != null) '',"proxyHost": "${cfg.ui.proxyHost}"''}
                  ${optionalString (cfg.ui.auth != null) '',"auth": "${cfg.ui.auth}"''}
                  ${
                    optionalString (
                      cfg.ui.sessionTimeout != null
                    ) '',"sessionTimeout": ${toString cfg.ui.sessionTimeout}''
                  }
                  ${
                    optionalString (cfg.ui.ssl != null) ''
                      ,"ssl": {
                        "key": "${cfg.ui.ssl.key}",
                        "cert": "${cfg.ui.ssl.cert}",
                        "pfx": "${cfg.ui.ssl.pfx}",
                        "passphrase": "${cfg.ui.ssl.passphrase}"
                      }''
                  }
                  ${optionalString (cfg.ui.tempUnits != null) '',"tempUnits": "${cfg.ui.tempUnits}"''}
                  ${optionalString (cfg.ui.theme != null) '',"theme": "${cfg.ui.theme}"''}
                  ${optionalString (cfg.ui.lang != null) '',"lang": "${cfg.ui.lang}"''}
                  ${
                    optionalString (cfg.ui.loginWallpaper != null) '',"loginWallpaper": "${cfg.ui.loginWallpaper}"''
                  }
                  ${
                    optionalString (
                      cfg.ui.scheduledBackupDisable != null
                    ) '',"scheduledBackupDisable": ${toString cfg.ui.scheduledBackupDisable}''
                  }
                  ${
                    optionalString (
                      cfg.ui.scheduledBackupPath != null
                    ) '',"scheduledBackupPath": "${cfg.ui.scheduledBackupPath}"''
                  }
                  ${optionalString (cfg.ui.debug != null) '',"debug": ${toString cfg.ui.debug}''}
                  ${
                    optionalString (
                      cfg.ui.disableServerMetricsMonitoring != null
                    ) '',"disableServerMetricsMonitoring": ${toString cfg.ui.disableServerMetricsMonitoring}''
                  }
                }
              else
                .
              end
            )
        EOF
          )

          # Apply all changes in a single jq operation
          ${pkgs.jq}/bin/jq "$jq_filter" "${cfg.userStoragePath}/config.json" | ${pkgs.jq}/bin/jq . > "${cfg.userStoragePath}/config.json.tmp"
          mv "${cfg.userStoragePath}/config.json.tmp" "${cfg.userStoragePath}/config.json"
        fi

        # Set proper permissions
        chown homebridge "${cfg.userStoragePath}/config.json"
        chgrp homebridge "${cfg.userStoragePath}/config.json"
        chmod 600 "${cfg.userStoragePath}/config.json"
        mkdir -p "${cfg.pluginPath}"
        chown homebridge "${cfg.pluginPath}"
        chgrp homebridge "${cfg.pluginPath}"
      '';

      # Settings found from standalone mode docs and hb-service code
      # https://github.com/homebridge/homebridge-config-ui-x/wiki/Standalone-Mode
      # https://github.com/homebridge/homebridge-config-ui-x/blob/a12ad881fe6df62d817ecb56f9fc6b7e82b6d078/src/bin/platforms/linux.ts#L714
      serviceConfig = {
        Type = "simple";
        User = "homebridge";
        PermissionsStartOnly = true;
        WorkingDirectory = cfg.userStoragePath;
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart = "${pkgs.homebridge}/bin/homebridge ${args}";
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
        User = "homebridge";
        PermissionsStartOnly = true;
        WorkingDirectory = cfg.userStoragePath;
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStart = "${pkgs.homebridge-config-ui-x}/bin/homebridge-config-ui-x ${args}";
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
    users.users.homebridge = {
      home = cfg.userStoragePath;
      createHome = true;
      group = "homebridge";
      # Necessary so that this user can run journalctl
      extraGroups = [ "systemd-journal" ];
      isSystemUser = true;
    };

    users.groups.homebridge = { };

    # Need passwordless sudo for a few commands
    # homebridge-config-ui-x needs for some features
    security.sudo.extraRules = [
      {
        users = [ "homebridge" ];
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
        cfg.bridge.port
        cfg.ui.port
      ];
      allowedUDPPorts = mkIf cfg.openFirewall [ 5353 ];
    };
  };
}
