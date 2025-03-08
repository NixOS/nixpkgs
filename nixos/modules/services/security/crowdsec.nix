{
  config,
  pkgs,
  lib,
  ...
}:
let

  format = pkgs.formats.yaml { };

  rootDir = "/var/lib/crowdsec";
  stateDir = "${rootDir}/state";
  confDir = "/etc/crowdsec/";
  hubDir = "${stateDir}/hub/";
  notificationsDir = "${confDir}/notifications/";
  pluginDir = "${confDir}/plugins/";
  parsersDir = "${confDir}/parsers/";
  localPostOverflowsDir = "${confDir}/postoverflows/";
  localPostOverflowsS01WhitelistDir = "${localPostOverflowsDir}/s01-whitelist/";
  localScenariosDir = "${confDir}/scenarios/";
  localParsersS00RawDir = "${parsersDir}/s00-raw/";
  localParsersS01ParseDir = "${parsersDir}/s01-parse/";
  localParsersS02EnrichDir = "${parsersDir}/s02-enrich/";
  localContextsDir = "${confDir}/contexts/";

in
{

  options.services.crowdsec = with lib; {
    enable = mkEnableOption "CrowdSec Security Engine";

    package = mkPackageOption pkgs "crowdsec" { };

    autoUpdateService = mkEnableOption "Auto Hub Update";

    user = mkOption {
      type = types.str;
      description = "The user to run crowdsec as";
      default = "crowdsec";
    };

    group = mkOption {
      type = types.str;
      description = "The group to run crowdsec as";
      default = "crowdsec";
    };

    name = mkOption {
      type = types.str;
      description = ''
        Name of the machine when registering it at the central or local api.
      '';
      default = config.networking.hostName;
      defaultText = "${config.networking.hostName}";
    };

    localConfig = mkOption {
      type = types.submodule {
        options = {
          acquisitions = mkOption {
            type = types.listOf format.type;
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
          scenarios = mkOption {
            type = types.listOf format.type;
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
          parsers = mkOption {
            type = types.submodule {
              options = {
                s00Raw = mkOption {
                  type = types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s00-raw specifications. Most of the time, those are already included in the hub, but are presented here anyway. See <https://docs.crowdsec.net/docs/parsers/intro> for details.
                  '';
                };
                s01Parse = mkOption {
                  type = types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s01-parse specifications. See <https://docs.crowdsec.net/docs/parsers/intro> for details.
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
                s02Enrich = mkOption {
                  type = types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s02-enrich specifications. Inside this list, you can specify Parser Whitelists. See <https://docs.crowdsec.net/docs/whitelist/intro> for details.
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
            default = { };
          };
          postOverflows = mkOption {
            type = types.submodule {
              options = {
                s01Whitelist = mkOption {
                  type = types.listOf format.type;
                  default = [ ];
                  description = ''
                    A list of stage s01-whitelist specifications. Inside this list, you can specify Postoverflows Whitelists. See <https://docs.crowdsec.net/docs/whitelist/intro> for details.
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
            default = { };
          };
          contexts = mkOption {
            type = types.listOf format.type;
            description = ''
              A list of additional contexts to specify. See <https://docs.crowdsec.net/docs/next/log_processor/alert_context/intro> for details.
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
          notifications = mkOption {
            type = types.listOf format.type;
            description = ''
              A list of notifications to enable and use in your profiles. Note that for now, only the plugins shipped by default with CrowdSec are supported. See <https://docs.crowdsec.net/docs/notification_plugins/intro> for details.
            '';
            example = [
              {
                type = "http";
                name = "default_http_notification";
                log_level = "info";
                format = ''
                  {{.|toJson}}
                '';
                url = "http://example.com/hook";
                method = "POST";
              }
            ];
            default = [ ];
          };
          profiles = mkOption {
            type = types.listOf format.type;
            description = ''
              A list of profiles to enable. See <https://docs.crowdsec.net/docs/profiles/intro> for more details.
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
          patterns = mkOption {
            type = types.listOf types.package;
            default = [ ];
            example = lib.literalExpression ''
              [ (pkgs.writeTextDir "custom_service_logs" (builtins.readFile ./custom_service_logs)) ]
            '';
          };
        };
      };
      default = { };
    };

    hub = mkOption {
      type = types.submodule {
        options = {
          collections = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of hub collections to install";
            example = [ "crowdsecurity/linux" ];
          };

          scenarios = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of hub scenarios to install";
            example = [ "crowdsecurity/ssh-bf" ];
          };

          parsers = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of hub parsers to install";
            example = [ "crowdsecurity/sshd-logs" ];
          };

          postOverflows = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of hub postoverflows to install";
            example = [ "crowdsecurity/auditd-nix-wrappers-whitelist-process" ];
          };

          appSecConfigs = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of hub appsec configurations to install";
            example = [ "crowdsecurity/appsec-default" ];
          };

          appSecRules = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of hub appsec rules to install";
            example = [ "crowdsecurity/base-config" ];
          };
        };
      };
      default = { };
      description = ''
        Hub collections, parsers, AppSec rules, etc.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        options = {
          general = mkOption {
            description = ''
              Settings for the main CrowdSec configuration file. Refer to the defaults at
              <https://github.com/crowdsecurity/crowdsec/blob/master/config/config.yaml>.
            '';
            type = format.type;
            default = { };
          };
          simulation = mkOption {
            type = format.type;
            default = {
              simulation = false;
            };
            description = ''
              Attributes inside the simulation.yaml file.
            '';
          };

          lapi = mkOption {
            type = types.submodule {
              options = {
                credentials = mkOption {
                  type = types.nullOr format.type;
                  default = null;
                  example = {
                    url = "http://localhost:8080";
                    login = "login";
                    password = "password";
                    ca_cert_path = "example";
                    key_path = "example";
                    cert_path = "example";
                  };
                  description = ''
                    Attributes inside the local_api_credentials file. This is not the most secure way to define settings, as this is put in the Nix store. Use of lapi.credentialsFile is preferred.
                  '';
                };
                credentialsFile = mkOption {
                  type = types.nullOr types.path;
                  example = "/run/crowdsec/lapi.yaml";
                  description = ''
                    The credential file to use. This is strongly preferred instead of putting secrets in the Nix store.
                  '';
                  default = null;
                };
              };
            };
            description = ''
              LAPI Configuration attributes
            '';
            default = { };
          };
          capi = mkOption {
            type = types.submodule {
              options = {
                credentials = mkOption {
                  type = types.nullOr format.type;
                  default = null;
                  example = {
                    url = "https://api.crowdsec.net/";
                    login = "abcdefghijklmnopqrstuvwxyz";
                    password = "abcdefghijklmnopqrstuvwxyz";
                  };
                  description = ''
                    Attributes inside the central_api_credentials.yaml file. This is not the most secure way to define settings, as this is put in the Nix store. Use of capi.credentialsFile is preferred.
                  '';
                };
                credentialsFile = mkOption {
                  type = types.nullOr types.path;
                  example = "/run/crowdsec/capi.yaml";
                  description = ''
                    The credential file to use. This is strongly preferred instead of putting secrets in the Nix store.
                  '';
                  default = null;
                };
              };
            };
            description = ''
              CAPI Configuration attributes
            '';
            default = { };
          };
          console = mkOption {
            type = types.submodule {
              options = {
                token = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "abcde";
                  description = ''
                    The console token to enroll to the web console. This is not the most secure way to define settings, as this is put in the Nix store. Use of console.tokenFile is preferred.
                  '';
                };
                tokenFile = mkOption {
                  type = types.nullOr types.path;
                  example = "/run/crowdsec/console_token.yaml";
                  description = ''
                    The credential file to use. This is strongly preferred instead of putting secrets in the Nix store.
                  '';
                  default = null;
                };
                configuration = mkOption {
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
      configFile = format.generate "crowdsec.yaml" cfg.settings.general;
      lapiFile =
        if cfg.settings.lapi.credentialsFile != null then
          cfg.settings.lapi.credentialsFile
        else
          format.generate "local_api_credentials.yaml" cfg.settings.lapi.credentials;
      capiFile =
        if cfg.settings.capi.credentialsFile != null then
          cfg.settings.capi.credentialsFile
        else
          (
            if cfg.settings.capi.credentials != null then
              format.generate "central_api_credentials.yaml" cfg.settings.capi.credentials
            else
              null
          );

      tokenFile =
        if cfg.settings.console.tokenFile != null then
          cfg.settings.console.tokenFile
        else
          (
            if cfg.settings.console.token != null then
              pkgs.writeText "console_token.txt" cfg.settings.console.token
            else
              null
          );
      simulationFile = format.generate "simulation.yaml" cfg.settings.simulation;
      consoleFile = format.generate "console.yaml" cfg.settings.console.configuration;
      patternsDir = pkgs.buildPackages.symlinkJoin {
        name = "crowdsec-patterns";
        paths = [
          cfg.localConfig.patterns
          (lib.attrsets.getOutput "patterns" pkg)
        ];
      };

      pkg = cfg.package;

      cscli = pkgs.writeScriptBin "cscli" ''
        #!${pkgs.runtimeShell}
        set -eu
        set -o pipefail

        # cscli needs crowdsec on it's path in order to be able to run `cscli explain`
        export PATH=$PATH:${lib.makeBinPath [ pkg ]}

        exec ${lib.getExe' pkg "cscli"} -c=${configFile} "''${@}"
      '';

      localScenariosMap = (map (format.generate "scenario.yaml") cfg.localConfig.scenarios);
      localParsersS00RawMap = (
        map (format.generate "parsers-s00-raw.yaml") cfg.localConfig.parsers.s00Raw
      );
      localParsersS01ParseMap = (
        map (format.generate "parsers-s01-parse.yaml") cfg.localConfig.parsers.s01Parse
      );
      localParsersS02EnrichMap = (
        map (format.generate "parsers-s02-enrich.yaml") cfg.localConfig.parsers.s02Enrich
      );
      localPostOverflowsS01WhitelistMap = (
        map (format.generate "postoverflows-s01-whitelist.yaml") cfg.localConfig.postOverflows.s01Whitelist
      );
      localContextsMap = (map (format.generate "context.yaml") cfg.localConfig.contexts);
      localNotificationsMap = (map (format.generate "notification.yaml") cfg.localConfig.notifications);
      localProfilesFile = pkgs.writeText "local_profiles.yaml" (
        lib.strings.concatMapStringsSep "\n---\n" (filename: builtins.readFile filename) (
          map (prof: format.generate "profile.yaml" prof) cfg.localConfig.profiles
        )
      );
      localAcquisisionFile = pkgs.writeText "local_acquisisions.yaml" (
        lib.strings.concatMapStringsSep "\n---\n" (filename: builtins.readFile filename) (
          map (prof: format.generate "acquisition.yaml" prof) cfg.localConfig.acquisitions
        )
      );

    in
    lib.mkIf (cfg.enable) {

      assertions = [
        {
          assertion = lib.trivial.xor (cfg.settings.lapi.credentials != null) (
            cfg.settings.lapi.credentialsFile != null
          );
          message = "Please specify either services.crowdsec.settings.lapi.credentialsFile or services.crowdsec.settings.lapi.credentials, not more, not less.";
        }
      ];

      warnings =
        [ ]
        ++ (
          if cfg.localConfig.profiles == [ ] then
            [
              "By not specifying profiles in services.crowdsec.localConfig.profiles, CrowdSec will not react to any alert by default"
            ]
          else
            [ ]
        )
        ++ (
          if cfg.localConfig.acquisitions == [ ] then
            [
              "By not specifying acquisitions in services.crowdsec.localConfig.acquisitions, CrowdSec will not look for any data source"
            ]
          else
            [ ]
        );

      services.crowdsec.settings.general = with lib; {
        common = {
          daemonize = mkDefault false;
          log_media = mkDefault "stdout";
        };
        config_paths = {
          config_dir = mkDefault confDir;
          data_dir = mkDefault stateDir;
          simulation_path = mkDefault simulationFile;
          hub_dir = mkDefault hubDir;
          index_path = mkDefault (lib.strings.normalizePath "${stateDir}/hub/.index.json");
          notification_dir = mkDefault notificationsDir;
          plugin_dir = mkDefault pluginDir;
          pattern_dir = mkDefault patternsDir;
        };
        db_config = {
          type = mkDefault "sqlite";
          db_path = mkDefault (lib.strings.normalizePath "${stateDir}/crowdsec.db");
          use_wal = mkDefault true;
        };
        crowdsec_service = {
          enable = mkDefault true;
          acquisition_path = mkDefault localAcquisisionFile;
        };
        api = {
          client = {
            credentials_path = mkDefault lapiFile;
          };
          server = {
            enable = mkDefault false;
            listen_uri = mkDefault "127.0.0.1:8080";

            console_path = mkDefault consoleFile;
            profiles_path = mkDefault localProfilesFile;

            online_client = mkDefault {
              sharing = mkDefault true;
              pull = mkDefault {
                community = mkDefault true;
                blocklists = mkDefault true;
              };
              credentials_path = mkDefault capiFile;
            };
          };
        };
        prometheus = {
          enabled = mkDefault true;
          level = mkDefault "full";
          listen_addr = mkDefault "127.0.0.1";
          listen_port = mkDefault 6060;
        };
        cscli = {
          hub_branch = "v${cfg.package.version}";
        };
      };

      environment = {
        systemPackages = [ cscli ];
      };

      systemd.packages = [ pkg ];
      systemd.timers.crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
        description = "Update the crowdsec hub index";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
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
            LimitNOFILE = lib.mkDefault 65536;
            CapabilityBoundingSet = lib.mkDefault [ ];
            NoNewPrivileges = lib.mkDefault true;
            LockPersonality = lib.mkDefault true;
            RemoveIPC = lib.mkDefault true;
            ReadWritePaths = [
              rootDir
              confDir
            ];
            ProtectSystem = lib.mkDefault "strict";
            PrivateUsers = lib.mkDefault true;
            ProtectHome = lib.mkDefault true;
            PrivateTmp = lib.mkDefault true;
            PrivateDevices = lib.mkDefault true;
            ProtectHostname = lib.mkDefault true;
            ProtectKernelTunables = lib.mkDefault true;
            ProtectKernelModules = lib.mkDefault true;
            ProtectControlGroups = lib.mkDefault true;
            ProtectProc = lib.mkDefault "invisible";
            RestrictNamespaces = lib.mkDefault true;
            RestrictRealtime = lib.mkDefault true;
            RestrictSUIDSGID = lib.mkDefault true;
            ExecPaths = [ "/nix/store" ];
            NoExecPaths = [ "/" ];
            ExecStart = "${lib.getExe cscli} --error hub update";
            ExecStartPost = "systemctl reload crowdsec.service";
          };
        };

        crowdsec = {
          description = "CrowdSec is a free, modern & collaborative behavior detection engine, coupled with a global IP reputation network.";
          path = [ cscli ];
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            Restart = "on-failure";

            LimitNOFILE = lib.mkDefault 65536;
            CapabilityBoundingSet = lib.mkDefault [ ];
            NoNewPrivileges = lib.mkDefault true;
            LockPersonality = lib.mkDefault true;
            RemoveIPC = lib.mkDefault true;
            ReadWritePaths = [
              rootDir
              confDir
            ];
            ProtectSystem = lib.mkDefault "strict";
            PrivateUsers = lib.mkDefault true;
            ProtectHome = lib.mkDefault true;
            PrivateTmp = lib.mkDefault true;
            PrivateDevices = lib.mkDefault true;
            ProtectHostname = lib.mkDefault true;
            ProtectKernelTunables = lib.mkDefault true;
            ProtectKernelModules = lib.mkDefault true;
            ProtectControlGroups = lib.mkDefault true;
            ProtectProc = lib.mkDefault "invisible";
            RestrictNamespaces = lib.mkDefault true;
            RestrictRealtime = lib.mkDefault true;
            RestrictSUIDSGID = lib.mkDefault true;
            ExecPaths = [ "/nix/store" ];
            NoExecPaths = [ "/" ];

            ExecStart = "${lib.getExe' pkg "crowdsec"} -c ${configFile}";
            ExecStartPre =
              let
                scriptArray =
                  [
                    "#!${pkgs.runtimeShell}"
                    "set -euxo pipefail"
                    "cscli hub update"
                  ]
                  ++ lib.optionals (cfg.hub.collections != [ ]) [
                    "cscli collections install ${
                      lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.collections
                    }"
                  ]
                  ++ lib.optionals (cfg.hub.scenarios != [ ]) [
                    "cscli scenarios install ${
                      lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.scenarios
                    }"
                  ]
                  ++ lib.optionals (cfg.hub.parsers != [ ]) [
                    "cscli parsers install ${
                      lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.parsers
                    }"
                  ]
                  ++ lib.optionals (cfg.hub.postOverflows != [ ]) [
                    "cscli postoverflows install ${
                      lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.postOverflows
                    }"
                  ]
                  ++ lib.optionals (cfg.hub.appSecConfigs != [ ]) [
                    "cscli appsec-configs install ${
                      lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.appSecConfigs
                    }"
                  ]
                  ++ lib.optionals (cfg.hub.appSecRules != [ ]) [
                    "cscli appsec-rules install ${
                      lib.strings.concatMapStringsSep " " (x: lib.escapeShellArg x) cfg.hub.appSecRules
                    }"
                  ]
                  ++ lib.optionals (cfg.settings.general.api.server.enable) [
                    ''
                      if [ ! -s "${cfg.settings.general.api.client.credentials_path}" ]; then
                        cscli machine add "${cfg.name}" --auto
                      fi
                    ''
                  ]
                  ++ lib.optionals (capiFile != null) [
                    ''
                      if ! grep -q password "${capiFile}" ]; then
                        cscli capi register
                      fi
                    ''
                  ]
                  ++ lib.optionals (tokenFile != null) [
                    ''
                      if [ ! -e "${tokenFile}" ]; then
                        cscli console enroll "$(cat ${tokenFile})" --name ${cfg.name}
                      fi
                    ''
                  ];

                script = pkgs.writeScriptBin "crowdsec-setup" (lib.strings.concatStringsSep "\n" scriptArray);
              in
              [ "${lib.getExe script}" ];
          };
        };
      };

      systemd.tmpfiles.rules = (
        [
          "d ${stateDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${hubDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${confDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localScenariosDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localPostOverflowsDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localPostOverflowsS01WhitelistDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${parsersDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localParsersS00RawDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localParsersS01ParseDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localParsersS02EnrichDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${localContextsDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${notificationsDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${pluginDir} 0750 ${cfg.user} ${cfg.group} - -"
        ]
        ++ (map (
          file: "L+ ${localScenariosDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localScenariosMap)
        ++ (map (
          file: "L+ ${localParsersS00RawDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localParsersS00RawMap)
        ++ (map (
          file: "L+ ${localParsersS01ParseDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localParsersS01ParseMap)
        ++ (map (
          file: "L+ ${localParsersS02EnrichDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localParsersS02EnrichMap)
        ++ (map (
          file: "L+ ${localPostOverflowsS01WhitelistDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localPostOverflowsS01WhitelistMap)
        ++ (map (
          file: "L+ ${localContextsDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localContextsMap)
        ++ (map (
          file: "L+ ${notificationsDir}/${builtins.baseNameOf file} - - - - ${file}"
        ) localNotificationsMap)
      );

      users.users.${cfg.user} = {
        name = lib.mkDefault cfg.user;
        description = lib.mkDefault "CrowdSec service user";
        isSystemUser = lib.mkDefault true;
        group = lib.mkDefault cfg.group;
        extraGroups = [ "systemd-journal" ];
      };

      users.groups.${cfg.group} = lib.mapAttrs (name: lib.mkDefault) { };
    };

  meta = {
    maintainers = with lib.maintainers; [
      m0ustach3
      jk
    ];
    buildDocsInSandbox = true;
  };
}
