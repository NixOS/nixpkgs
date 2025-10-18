{ config
, pkgs
, lib
, ...
}:
let

  format = pkgs.formats.yaml { };

  rootDir = "/var/lib/crowdsec";
  dataDir = "${rootDir}/data";
  confDir = "/etc/crowdsec";
  confFile = "${confDir}/config.yaml";
  hubDir = "${confDir}/hub";
  notificationsDir = "${confDir}/notifications";
  pluginDir = "${confDir}/plugins";
  parsersDir = "${confDir}/parsers";

  localPostOverflowsDir = "${confDir}/postoverflows";
  localPostOverflowsS01WhitelistDir = "${localPostOverflowsDir}/s01-whitelist";
  localScenariosDir = "${confDir}/scenarios";
  localParsersS00RawDir = "${parsersDir}/s00-raw";
  localParsersS01ParseDir = "${parsersDir}/s01-parse";
  localParsersS02EnrichDir = "${parsersDir}/s02-enrich";
  localContextsDir = "${confDir}/contexts";

in
{

  options.services.crowdsec = {
    enable = lib.mkEnableOption "CrowdSec Security Engine";

    package = lib.mkPackageOption pkgs "crowdsec" { };

    autoUpdateService = lib.mkEnableOption "if `true` `cscli hub update` will be executed daily. See `https://docs.crowdsec.net/docs/cscli/cscli_hub_update/` for more information";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to automatically open firewall ports for `crowdsec`.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "The user to run crowdsec as";
      default = "crowdsec";
    };

    group = lib.mkOption {
      type = lib.types.str;
      description = "The group to run crowdsec as";
      default = "crowdsec";
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = ''
        Name of the machine when registering it at the central or local api.
      '';
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
    };

    hub = lib.mkOption {
      description = ''
        Hub collections, parsers, AppSec rules, etc.
      '';
      type = lib.types.submodule {
        options = {
          collections = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub collections to install";
            example = [ "crowdsecurity/linux" ];
          };

          scenarios = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub scenarios to install";
            example = [ "crowdsecurity/ssh-bf" ];
          };

          parsers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub parsers to install";
            example = [ "crowdsecurity/sshd-logs" ];
          };

          postOverflows = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub postoverflows to install";
            example = [ "crowdsecurity/auditd-nix-wrappers-whitelist-process" ];
          };

          appSecConfigs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub appsec configurations to install";
            example = [ "crowdsecurity/appsec-default" ];
          };

          appSecRules = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub appsec rules to install";
            example = [ "crowdsecurity/base-config" ];
          };

          branch = lib.mkOption {
            type = lib.types.str;
            default = "master";
            description = ''
              The git branch on which cscli is going to fetch configurations.

              See `https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#hub_branch` for more information.
            '';
            example = [
              "master"
              "v1.4.3"
              "v1.4.2"
            ];
          };
        };
      };
      default = { };
    };

    settings = lib.mkOption {
      description = "Config options for the main config file.";
      type = lib.types.submodule {
        options = {
          general = lib.mkOption {
            description = ''
              Additional settings for the main CrowdSec configuration file.

              Refer to the defaults at <https://github.com/crowdsecurity/crowdsec/blob/master/config/config.yaml>.

              See here for possible values: <https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#configuration-directives>.
            '';
            type = lib.types.submodule {
              freeformType = format.type;
            };
            default = { };
            example = {
              common = {
                log_level = "info";
              };

              api = {
                client = {
                  credentials_path = "/var/lib/crowdsec/local_api_credentials.yaml";
                };
                server = {
                  enable = false;
                  online_client.credentials_path = "/var/lib/crowdsec/online_api_credentials.yaml";
                };
              };
            };
          };

          simulation = lib.mkOption {
            type = format.type;
            default = {
              simulation = false;
            };
            description = ''
              Attributes inside the simulation.yaml file.
            '';
          };


          acquisitions = lib.mkOption {
            type = lib.types.listOf format.type;
            default = [ ];
            description = ''
              A list of acquisition specifications, which define the data sources you want to be parsed.

              See <https://docs.crowdsec.net/docs/data_sources/intro> for details.
            '';
            example = [
              {
                source = "journalctl";
                journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
                labels = {
                  type = "syslog";
                };
              }
            ];
          };
          scenarios = lib.mkOption {
            type = lib.types.listOf format.type;
            default = [ ];
            description = ''
              A list of scenarios specifications.

              See <https://docs.crowdsec.net/docs/scenarios/intro> for details.
            '';
            example = [
              {
                type = "leaky";
                name = "crowdsecurity/myservice-bf";
                description = "Detect myservice bruteforce";
                filter = "evt.Meta.log_type == 'myservice_failed_auth'";
                leakspeed = "10s";
                capacity = 5;
                groupby = "evt.Meta.source_ip";
              }
            ];
          };
          parsers = lib.mkOption {
            type = lib.types.submodule {
              options = {
                s00Raw = lib.mkOption {
                  type = lib.types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s00-raw specifications. Most of the time, those are already included in the hub, but are presented here anyway.

                    See <https://docs.crowdsec.net/docs/parsers/intro> for details.
                  '';
                };
                s01Parse = lib.mkOption {
                  type = lib.types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s01-parse specifications.

                    See <https://docs.crowdsec.net/docs/parsers/intro> for details.
                  '';
                  example = [
                    {
                      filter = "1=1";
                      debug = true;
                      onsuccess = "next_stage";
                      name = "example/custom-service-logs";
                      description = "Parsing custom service logs";
                      grok = {
                        pattern = "^%{DATA:some_data}$";
                        apply_on = "message";
                      };
                      statics = [
                        {
                          parsed = "is_my_custom_service";
                          value = "yes";
                        }
                      ];
                    }
                  ];
                };
                s02Enrich = lib.mkOption {
                  type = lib.types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s02-enrich specifications. Inside this list, you can specify Parser Whitelists.

                    See <https://docs.crowdsec.net/docs/whitelist/intro> for details.
                  '';
                  example = [
                    {
                      name = "myips/whitelist";
                      description = "Whitelist parse events from my IPs";
                      whitelist = {
                        reason = "My IP ranges";
                        ip = [
                          "1.2.3.4"
                        ];
                        cidr = [
                          "1.2.3.0/24"
                        ];
                      };
                    }
                  ];
                };
              };
            };
            description = ''
              The set of parser specifications.

              See <https://docs.crowdsec.net/docs/parsers/intro> for details.
            '';
            default = { };
          };
          postOverflows = lib.mkOption {
            type = lib.types.submodule {
              options = {
                s01Whitelist = lib.mkOption {
                  type = lib.types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s01-whitelist specifications. Inside this list, you can specify Postoverflows Whitelists.

                    See <https://docs.crowdsec.net/docs/whitelist/intro> for details.
                  '';
                  example = [
                    {
                      name = "postoverflows/whitelist_my_dns_domain";
                      description = "Whitelist my reverse DNS";
                      whitelist = {
                        reason = "Don't ban me";
                        expression = [
                          "evt.Enriched.reverse_dns endsWith '.local.'"
                        ];
                      };
                    }
                  ];
                };
              };
            };
            description = ''
              The set of Postoverflows specifications.

              See <https://docs.crowdsec.net/docs/next/log_processor/parsers/intro#postoverflows> for details.
            '';
            default = { };
          };
          contexts = lib.mkOption {
            type = lib.types.listOf format.type;
            description = ''
              A list of additional contexts to specify.

              See <https://docs.crowdsec.net/docs/next/log_processor/alert_context/intro> for details.
            '';
            example = [
              {
                context = {
                  target_uri = [ "evt.Meta.http_path" ];
                  user_agent = [ "evt.Meta.http_user_agent" ];
                  method = [ "evt.Meta.http_verb" ];
                  status = [ "evt.Meta.http_status" ];
                };
              }
            ];
            default = [ ];
          };
          notifications = lib.mkOption {
            type = lib.types.listOf format.type;
            description = ''
              A list of notifications to enable and use in your profiles. Note that for now, only the plugins shipped by default with CrowdSec are supported.

              See <https://docs.crowdsec.net/docs/notification_plugins/intro> for details.
            '';
            example = [
              {
                type = "http";
                name = "default_http_notification";
                log_level = "info";
                format = ''
                  {{.|toJson}}
                '';
                url = "https://example.com/hook";
                method = "POST";
              }
            ];
            default = [ ];
          };
          profiles = lib.mkOption {
            type = lib.types.listOf format.type;
            description = ''
              A list of profiles to enable.

              See <https://docs.crowdsec.net/docs/profiles/intro> for more details.
            '';
            example = [
              {
                name = "default_ip_remediation";
                filters = [
                  "Alert.Remediation == true && Alert.GetScope() == 'Ip'"
                ];
                decisions = [
                  {
                    type = "ban";
                    duration = "4h";
                  }
                ];
                on_success = "break";
              }
              {
                name = "default_range_remediation";
                filters = [
                  "Alert.Remediation == true && Alert.GetScope() == 'Range'"
                ];
                decisions = [
                  {
                    type = "ban";
                    duration = "4h";
                  }
                ];
                on_success = "break";
              }
            ];
            default = [
              {
                name = "default_ip_remediation";
                filters = [
                  "Alert.Remediation == true && Alert.GetScope() == 'Ip'"
                ];
                decisions = [
                  {
                    type = "ban";
                    duration = "4h";
                  }
                ];
                on_success = "break";
              }
              {
                name = "default_range_remediation";
                filters = [
                  "Alert.Remediation == true && Alert.GetScope() == 'Range'"
                ];
                decisions = [
                  {
                    type = "ban";
                    duration = "4h";
                  }
                ];
                on_success = "break";
              }
            ];
          };
          patterns = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            description = ''
              A list of files containing custom grok patterns.
            '';
            default = [ ];
            example = lib.literalExpression ''
              [ (pkgs.writeTextDir "custom_service_logs" (builtins.readFile ./custom_service_logs)) ]
            '';
          };

          console = lib.mkOption {
            type = lib.types.submodule {
              options = {
                tokenFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  example = "/run/crowdsec/console_token.yaml";
                  description = ''
                    The Console Token file to use.
                  '';
                  default = null;
                };
                configuration = lib.mkOption {
                  type = format.type;
                  default = {
                    share_manual_decisions = false;
                    share_custom = false;
                    share_tainted = false;
                    share_context = false;
                  };
                  description = ''
                    Attributes inside the console.yaml file.
                  '';
                };
              };
            };
            description = ''
              Console Configuration attributes
            '';
            default = { };
          };
        };
      };
    };
  };
  config =
    let
      cfg = config.services.crowdsec;

      configFile = format.generate "config.yaml" cfg.settings.general;
      simulationFile = format.generate "simulation.yaml" cfg.settings.simulation;
      consoleFile = format.generate "console.yaml" cfg.settings.console.configuration;
      patternsDir = pkgs.buildPackages.symlinkJoin {
        name = "crowdsec-patterns";
        paths = [
          cfg.settings.patterns
          "${lib.attrsets.getOutput "out" cfg.package}/share/crowdsec/config/patterns/"
        ];
      };

      cscli = pkgs.writeShellScriptBin "cscli" ''
        set -euo pipefail
        sudo=exec
        if [ "$USER" != "${cfg.user}" ]; then
          ${
            if config.security.sudo.enable then
              "sudo='exec ${config.security.wrapperDir}/sudo -u ${cfg.user}'"
            else
              ">&2 echo 'Aborting, cscli must be run as user `${cfg.user}`!'; exit 2"
          }
        fi
        $sudo ${lib.getExe' cfg.package "cscli"} -c=${configFile} "$@"
      '';

      localScenariosMap = (map (format.generate "scenario.yaml") cfg.settings.scenarios);
      localParsersS00RawMap = (
        map (format.generate "parsers-s00-raw.yaml") cfg.settings.parsers.s00Raw
      );
      localParsersS01ParseMap = (
        map (format.generate "parsers-s01-parse.yaml") cfg.settings.parsers.s01Parse
      );
      localParsersS02EnrichMap = (
        map (format.generate "parsers-s02-enrich.yaml") cfg.settings.parsers.s02Enrich
      );
      localPostOverflowsS01WhitelistMap = (
        map (format.generate "postoverflows-s01-whitelist.yaml") cfg.settings.postOverflows.s01Whitelist
      );
      localContextsMap = (map (format.generate "context.yaml") cfg.settings.contexts);
      localNotificationsMap = (map (format.generate "notification.yaml") cfg.settings.notifications);
      localProfilesFile = pkgs.writeText "local_profiles.yaml" ''
        ---
        ${lib.strings.concatMapStringsSep "\n---\n" builtins.toJSON cfg.settings.profiles}
        ---
      '';
      localAcquisisionFile = pkgs.writeText "local_acquisisions.yaml" ''
        ---
        ${lib.strings.concatMapStringsSep "\n---\n" builtins.toJSON cfg.settings.acquisitions}
        ---
      '';

      scriptArray = [
        "mkdir -p '${hubDir}'"
        "${lib.getExe cscli} hub update"
      ]
      ++ lib.optional (cfg.hub.collections != [ ])
        "${lib.getExe cscli} collections install ${lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.collections}"

      ++ lib.optional (cfg.hub.scenarios != [ ])
        "${lib.getExe cscli} scenarios install ${lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.scenarios}"

      ++ lib.optional (cfg.hub.parsers != [ ])
        "${lib.getExe cscli} parsers install ${lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.parsers}"

      ++ lib.optional (cfg.hub.postOverflows != [ ])
        "${lib.getExe cscli} postoverflows install ${lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.postOverflows}"

      ++ lib.optional (cfg.hub.appSecConfigs != [ ])
        "${lib.getExe cscli} appsec-configs install ${lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.appSecConfigs}"

      ++ lib.optional (cfg.hub.appSecRules != [ ])
        "${lib.getExe cscli} appsec-rules install ${lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.appSecRules}"

      ++ lib.optional (cfg.settings.general.api.server.online_client.credentials_path != null)
        ''
          if ! grep -q password "${cfg.settings.general.api.server.online_client.credentials_path}";  then
            ${lib.getExe cscli} capi register
          fi
        ''

      ++ lib.optional cfg.settings.general.api.server.enable
        ''
          if [ ! -s "${cfg.settings.general.api.client.credentials_path}" ]; then
            ${lib.getExe cscli} machine add "${cfg.name}" --auto
          fi
        ''

      ++ lib.optional (cfg.settings.console.tokenFile != null)
        ''
          ${lib.getExe cscli} console enroll "$(cat ${cfg.settings.console.tokenFile})" --name ${cfg.name}
        ''
      ;

      setupScript = pkgs.writeShellApplication {
        name = "crowdsec-setup";

        runtimeInputs = with pkgs; [
          coreutils
          gnugrep
        ] ++ [
          # cscli needs crowdsec on it's path in order to be able to run `cscli explain`
          cfg.package
        ];

        text = lib.strings.concatStringsSep "\n" scriptArray;
      };

    in
    lib.mkIf (cfg.enable) {

      warnings =
        [ ]
        ++ lib.optionals (cfg.settings.profiles == [ ]) [
          "By not specifying profiles in services.crowdsec.settings.profiles, CrowdSec will not react to any alert by default."
        ]
        ++ lib.optionals (cfg.settings.acquisitions == [ ]) [
          "By not specifying acquisitions in services.crowdsec.settings.acquisitions, CrowdSec will not look for any data source."
        ];

      services.crowdsec.settings.general = {
        common = {
          daemonize = false;
          log_media = "stdout";
        };
        config_paths = {
          config_dir = confDir;
          data_dir = dataDir;
          simulation_path = simulationFile;
          hub_dir = hubDir;
          index_path = "${confDir}/hub/.index.json";
          notification_dir = notificationsDir;
          plugin_dir = pluginDir;
          pattern_dir = patternsDir;
        };
        db_config = {
          type = lib.mkDefault "sqlite";
          db_path = lib.mkDefault "${dataDir}/crowdsec.db";
          use_wal = lib.mkDefault true;
        };
        crowdsec_service = {
          enable = lib.mkDefault true;
          acquisition_path = lib.mkDefault localAcquisisionFile;
        };
        api = {
          client = {
            credentials_path = lib.mkDefault "${confDir}/local_api_credentials.yaml";
          };
          server = {
            enable = lib.mkDefault true;
            listen_uri = lib.mkDefault "127.0.0.1:8080";

            console_path = lib.mkDefault consoleFile;
            profiles_path = lib.mkDefault localProfilesFile;

            online_client = lib.mkDefault {
              sharing = lib.mkDefault true;
              pull = lib.mkDefault {
                community = lib.mkDefault true;
                blocklists = lib.mkDefault true;
              };
              credentials_path = lib.mkDefault null;
            };
          };
        };
        prometheus = {
          enabled = lib.mkDefault false;
          level = lib.mkDefault "full";
          listen_addr = lib.mkDefault "127.0.0.1";
          listen_port = lib.mkDefault 6060;
        };
        cscli = {
          hub_branch = cfg.hub.branch;
        };
      };

      environment = {
        systemPackages = [ cscli ];
      };

      systemd.packages = [ cfg.package ];

      systemd.timers.crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
        description = "Update the crowdsec hub index";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          RandomizedDelaySec = 300;
          Persistent = "yes";
          Unit = "crowdsec-update-hub.service";
        };
      };
      systemd.services = {
        crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
          description = "Update the crowdsec hub index";
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            LimitNOFILE = 65536;
            NoNewPrivileges = true;
            LockPersonality = true;
            RemoveIPC = true;
            ProtectSystem = "strict";
            PrivateUsers = true;
            ProtectHome = true;
            PrivateTmp = true;
            PrivateDevices = true;
            ProtectHostname = true;
            UMask = "0077";
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            ProtectProc = "invisible";

            StateDirectory = "crowdsec ";
            StateDirectoryMode = "0750";

            ConfigurationDirectory = "crowdsec";
            ConfigurationDirectoryMode = "0750";

            SystemCallFilter = [
              " " # This is needed to clear the SystemCallFilter existing definitions
              "~@reboot"
              "~@swap"
              "~@obsolete"
              "~@mount"
              "~@module"
              "~@debug"
              "~@cpu-emulation"
              "~@clock"
              "~@raw-io"
              "~@privileged"
              "~@resources"
            ];
            CapabilityBoundingSet = [
              " " # Reset all capabilities to an empty set
            ];
            RestrictAddressFamilies = [
              " " # This is needed to clear the RestrictAddressFamilies existing definitions
              "none" # Remove all addresses families
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];
            DevicePolicy = "closed";
            ProtectKernelLogs = true;
            SystemCallArchitectures = "native";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            ExecStart = "${lib.getExe cscli} --error hub update";
            ExecStartPost = "systemctl reload crowdsec.service";
            DynamicUser = true;
          };
        };

        crowdsec = {
          description = "CrowdSec agent";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          path = lib.mkForce [ ];
          environment = {
            LC_ALL = "C";
            LANG = "C";
          };
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            Type = "notify";
            RestartSec = 60;
            LimitNOFILE = 65536;
            NoNewPrivileges = true;
            LockPersonality = true;
            RemoveIPC = true;
            ReadWritePaths = [
              rootDir
              confDir
            ];
            ProtectSystem = "strict";
            PrivateUsers = true;
            ProtectHome = true;
            PrivateTmp = true;
            PrivateDevices = true;
            ProtectHostname = true;
            ProtectClock = true;
            UMask = "0077";
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            ProtectProc = "invisible";
            SystemCallFilter = [
              " " # This is needed to clear the SystemCallFilter existing definitions
              "~@reboot"
              "~@swap"
              "~@obsolete"
              "~@mount"
              "~@module"
              "~@debug"
              "~@cpu-emulation"
              "~@clock"
              "~@raw-io"
              "~@privileged"
              "~@resources"
            ];
            CapabilityBoundingSet = [
              " " # Reset all capabilities to an empty set
              "CAP_SYSLOG" # Add capability to read syslog
            ];
            RestrictAddressFamilies = [
              " " # This is needed to clear the RestrictAddressFamilies existing definitions
              "none" # Remove all addresses families
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
            ];
            DevicePolicy = "closed";
            ProtectKernelLogs = true;
            SystemCallArchitectures = "native";
            DynamicUser = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            ExecReload = [
              " " # This is needed to clear the ExecReload definitions from upstream
            ];
            ExecStart = [
              " " # This is needed to clear the ExecStart definitions from upstream
              "${lib.getExe' cfg.package "crowdsec"} -info"
            ];
            ExecStartPre = [
              " " # This is needed to clear the ExecStartPre definitions from upstream
              "${lib.getExe setupScript}"
              "${lib.getExe' cfg.package "crowdsec"} -t -error"
            ];
          };
        };
      };

      systemd.tmpfiles.settings = {
        "10-crowdsec" =

          builtins.listToAttrs
            (
              map
                (dirName: {
                  inherit cfg;
                  name = lib.strings.normalizePath dirName;
                  value = {
                    d = {
                      user = cfg.user;
                      group = cfg.group;
                      mode = "0750";
                    };
                  };
                })
                [
                  dataDir
                  hubDir
                  localScenariosDir
                  localPostOverflowsDir
                  localPostOverflowsS01WhitelistDir
                  parsersDir
                  localParsersS00RawDir
                  localParsersS01ParseDir
                  localParsersS02EnrichDir
                  localContextsDir
                  notificationsDir
                  pluginDir
                ]
            )
          // builtins.listToAttrs (
            map
              (scenarioFile: {
                inherit cfg;
                name = lib.strings.normalizePath "${localScenariosDir}/${builtins.baseNameOf scenarioFile}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${scenarioFile}";
                  };
                };
              })
              localScenariosMap
          )
          // builtins.listToAttrs (
            map
              (parser: {
                inherit cfg;
                name = lib.strings.normalizePath "${localParsersS00RawDir}/${builtins.baseNameOf parser}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${parser}";
                  };
                };
              })
              localParsersS00RawMap
          )
          // builtins.listToAttrs (
            map
              (parser: {
                inherit cfg;
                name = lib.strings.normalizePath "${localParsersS01ParseDir}/${builtins.baseNameOf parser}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${parser}";
                  };
                };
              })
              localParsersS01ParseMap
          )
          // builtins.listToAttrs (
            map
              (parser: {
                inherit cfg;
                name = lib.strings.normalizePath "${localParsersS02EnrichDir}/${builtins.baseNameOf parser}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${parser}";
                  };
                };
              })
              localParsersS02EnrichMap
          )
          // builtins.listToAttrs (
            map
              (postoverflow: {
                inherit cfg;
                name = lib.strings.normalizePath "${localPostOverflowsS01WhitelistDir}/${builtins.baseNameOf postoverflow}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${postoverflow}";
                  };
                };
              })
              localPostOverflowsS01WhitelistMap
          )
          // builtins.listToAttrs (
            map
              (context: {
                inherit cfg;
                name = lib.strings.normalizePath "${localContextsDir}/${builtins.baseNameOf context}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${context}";
                  };
                };
              })
              localContextsMap
          )
          // builtins.listToAttrs (
            map
              (notification: {
                inherit cfg;
                name = lib.strings.normalizePath "${notificationsDir}/${builtins.baseNameOf notification}";
                value = {
                  link = {
                    type = "L+";
                    argument = "${notification}";
                  };
                };
              })
              localNotificationsMap
          )
          // {
            "${lib.strings.normalizePath confFile}" = {
              link = {
                type = "L+";
                argument = lib.strings.normalizePath "${configFile}";
              };
            };
          }
        ;
      };

      users.users.${cfg.user} = {
        name = cfg.user;
        description = lib.mkDefault "CrowdSec service user";
        isSystemUser = true;
        group = cfg.group;
        extraGroups = [ "systemd-journal" ];
      };

      users.groups.${cfg.group} = lib.mapAttrs (name: lib.mkDefault) { };

      networking.firewall.allowedTCPPorts =
        let
          parsePortFromURLOption =
            url: option:
            builtins.addErrorContext "extracting a port from URL: `${option}` requires a port to be specified, but we failed to parse a port from '${url}'" (
              lib.strings.toInt (lib.last (lib.strings.splitString ":" url))
            );
        in
        lib.mkIf cfg.openFirewall [
          cfg.settings.general.prometheus.listen_port
          (parsePortFromURLOption cfg.settings.general.api.server.listen_uri "config.services.crowdsec.settings.general.api.server.listen_uri")
        ];
    };

  meta = {
    maintainers = with lib.maintainers; [
      m0ustach3
      tornax
      jk
    ];
  };
}
