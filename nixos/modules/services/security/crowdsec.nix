{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.crowdsec;
  yaml = pkgs.formats.yaml { };
  config_paths = cfg.settings.config.config_paths;

  # Reason:
  # https://github.com/NixOS/nixpkgs/pull/446307#issuecomment-3955091336
  secret_path = lib.types.either lib.types.path lib.types.nonEmptyStr;
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "crowdsec"
      "localConfig"
    ] "Please move options to `services.crowdsec.settings`.")

    (lib.mkChangedOptionModule
      [ "services" "crowdsec" "enrollKeyFile" ]
      [ "services" "crowdsec" "settings" "console" "enrollKeyFile" ]
      (config: config.services.crowdsec.enrollKeyFile)
    )

    (lib.mkChangedOptionModule
      [ "services" "crowdsec" "settings" "capi" "credentialsFile" ]
      [
        "services"
        "crowdsec"
        "settings"
        "config"
        "api"
        "server"
        "online_client"
        "credentials_path"
      ]
      (config: config.services.crowdsec.settings.capi.credentialsFile)
    )
    (lib.mkChangedOptionModule
      [ "services" "crowdsec" "settings" "lapi" "credentialsFile" ]
      [
        "services"
        "crowdsec"
        "settings"
        "config"
        "api"
        "client"
        "credentials_path"
      ]
      (config: config.services.crowdsec.settings.lapi.credentialsFile)
    )
  ];

  options.services.crowdsec = {
    enable = lib.mkEnableOption "CrowdSec Security Engine";

    package = lib.mkPackageOption pkgs "crowdsec" { };

    autoUpdateService = lib.mkEnableOption "if `true` `cscli hub update` will be executed daily. See `https://docs.crowdsec.net/docs/cscli/cscli_hub_update/` for more information";

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

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of additional groups that are assigned to the crowdsec user.

        The main usecase for this is to allow reading group readable log files.
      '';
      defaultText = lib.literalExpression ''[ "systemd-journal" ]'';
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = ''
        Name of the machine when registering it at the central or local api.
      '';
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
    };

    readOnlyPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        Additional read-only paths from the host which the crowdsec service can access.

        The main usecase for this is to allow crowdsec to read additional log files.
      '';
      default = [ ];
      example = [
        "/var/log/vaultwarden"
        "/var/log/nginx"
      ];
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

          postoverflows = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub postoverflows to install";
            example = [ "crowdsecurity/auditd-nix-wrappers-whitelist-process" ];
          };

          appsec-configs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub appsec configurations to install";
            example = [ "crowdsecurity/appsec-default" ];
          };

          appsec-rules = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "List of hub appsec rules to install";
            example = [ "crowdsecurity/base-config" ];
          };
        };
      };
      default = { };
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          config = lib.mkOption {
            description = ''
              Settings for the main CrowdSec configuration file.

              Defaults are _mostly_ equal to the default linux config file: <https://github.com/crowdsecurity/crowdsec/blob/master/config/config.yaml>.

              See the upstream documenation for possible values: <https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#configuration-directives>.
            '';
            type = lib.types.submodule {
              freeformType = yaml.type;
              options = {
                common = {
                  log_media = lib.mkOption {
                    type = lib.types.enum [
                      "stdout"
                      "file"
                    ];
                    default = "stdout";
                    description = "Log media";
                  };
                };

                config_paths = {
                  config_dir = lib.mkOption {
                    type = lib.types.path;
                    default = "/etc/crowdsec";
                    description = "Main configuration directory of crowdsec.";
                  };

                  data_dir = lib.mkOption {
                    type = lib.types.path;
                    default = "/var/lib/crowdsec/data";
                    description = "This is where crowdsec is going to store data, such as files downloaded by scenarios, geolocalisation database, metabase configuration database, or even SQLite database.";
                  };

                  simulation_path = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.config_dir}/simulation.yaml";
                    defaultText = lib.literalExpression "\${config_paths.config_dir}/simulation.yaml";
                    description = ''
                      This file is generated from `config.services.crowdsec.settings.simulation`.
                    '';
                  };

                  hub_dir = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.data_dir}/hub";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/hub";
                    description = "Directory where `cscli` will store parsers, scenarios, collections and such.";
                  };

                  index_path = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.hub_dir}/.index.json";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.hub_dir}/.index.json";
                    description = "Path to the `.index.json` file downloaded by `cscli` to know the list of available configurations.";
                  };

                  notification_dir = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.config_dir}/notifications";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.config_dir}/notifications";
                    description = "Path to directory where configuration files for notification plugins are kept.";
                  };

                  plugin_dir = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.config_dir}/plugins";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.config_dir}/plugins";
                    description = "Path to directory where the plugin binaries/scripts are located.";
                  };

                  pattern_dir = lib.mkOption {
                    type = lib.types.path;
                    default = pkgs.symlinkJoin {
                      name = "crowdsec-patterns";
                      paths = [
                        cfg.settings.patterns
                        "${cfg.package.out}/share/crowdsec/config/patterns/"
                      ];
                    };
                    defaultText = ''
                      A directory which contains the patterns of `config.services.crowdsec.settings.patterns` and the patterns
                      from this directory: <https://github.com/crowdsecurity/crowdsec/tree/master/config/patterns>.
                    '';
                    description = "Path to directory where pattern files are located.";
                  };
                };

                crowdsec_service = {
                  acquisition_dir = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.config_dir}/acquis.d";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.config_dir}/acquis.d";
                    description = ''
                      Path to a directory where each yaml is considered as a acquisition configuration file containing logs that needs to be read.
                      If both acquisition_dir and acquisition_path are specified, the entries are merged altogether.
                    '';
                  };
                };

                cscli = {
                  hub_branch = lib.mkOption {
                    type = lib.types.nullOr lib.types.nonEmptyStr;
                    default = null;
                    description = ''
                      The git branch on which cscli is going to fetch configurations.

                      See <https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#hub_branch> for more information.
                    '';
                  };
                };

                plugin_config = {
                  user = lib.mkOption {
                    type = lib.types.str;
                    description = "The user to run crowdsec plugins as";
                    default = cfg.user;
                    defaultText = lib.literalExpression "\${config.services.crowdsec.user}";
                  };

                  group = lib.mkOption {
                    type = lib.types.str;
                    description = "The group to run crowdsec plugins as";
                    default = cfg.group;
                    defaultText = lib.literalExpression "\${config.services.crowdsec.group}";
                  };
                };

                db_config = {
                  db_path = lib.mkOption {
                    type = lib.types.path;
                    default = "${config_paths.data_dir}/crowdsec.db";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/crowdsec.db";
                    description = "The path to the database file (only if the type of database is `sqlite`) or path to socket file (only if the type of database is `mysql|pgx`)";
                  };
                  type = lib.mkOption {
                    type = lib.types.enum [
                      "sqlite"
                      "mysql"
                      "pgx"
                    ];
                    default = "sqlite";
                    description = "The database type";
                  };
                };

                api = {
                  client.credentials_path = lib.mkOption {
                    type = secret_path;
                    default = "${config_paths.data_dir}/local_api_credentials.yaml";
                    defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/local_api_credentials.yaml";
                    description = "Path to the credential file that contains the API URL and login/password.";
                  };

                  server = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Whether to enable the CrowdSec Local API.";
                    };

                    listen_uri = lib.mkOption {
                      type = lib.types.nonEmptyStr;
                      default = "127.0.0.1:8080";
                      description = "The address and port on which the API will listen on in the form of `host:port`.";
                    };

                    profiles_path = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.config_dir}/profiles.yaml";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.config_dir}/profiles.yaml";
                      description = "Path to the profiles file.";
                    };

                    console_path = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.data_dir}/console.yaml";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/console.yaml";
                      description = "The path to the console configuration.";
                    };

                    online_client.credentials_path = lib.mkOption {
                      type = lib.types.nullOr secret_path;
                      default = null;
                      example = "\${config.services.crowdsec.settings.config.config_paths.data_dir}/online_api_credentials.yaml";
                      description = ''
                        Path to a file containing credentials for the Central API.
                        To automatically register with `crowdsec-setup`, set this option (typically to ''${config.services.crowdsec.settings.config.config_paths.data_dir}/online_api_credentials.yaml).
                        The file will be automatically created, unless it already exists.
                      '';
                    };
                  };
                };
              };
            };
          };

          simulation = lib.mkOption {
            type = yaml.type;
            default = {
              simulation = false;
            };
            description = ''
              Attributes inside the simulation.yaml file.
            '';
          };

          acquisitions = lib.mkOption {
            type = lib.types.listOf yaml.type;
            default = [
              {
                source = "journalctl";
                journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
                labels = {
                  type = "syslog";
                };
              }
            ];
            description = ''
              A list of acquisition specifications, which define the data sources you want to be parsed.

              See <https://docs.crowdsec.net/u/getting_started/post_installation/acquisition/> for details.
            '';
          };

          scenarios = lib.mkOption {
            type = lib.types.listOf yaml.type;
            default = [ ];
            description = ''
              A list of scenarios specifications.

              See <https://docs.crowdsec.net/docs/next/log_processor/scenarios/create/> for details.
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
                  type = lib.types.listOf yaml.type;
                  default = [ ];
                  description = ''
                    A list of stage s00-raw specifications. Most of the time, those are already included in the hub, but are presented here anyway.

                    See <https://docs.crowdsec.net/docs/next/log_processor/parsers/intro/#s00-raw> for details.
                  '';
                };
                s01Parse = lib.mkOption {
                  type = lib.types.listOf yaml.type;
                  default = [ ];
                  description = ''
                    A list of stage s01-parse specifications.

                    See <https://docs.crowdsec.net/docs/next/log_processor/parsers/intro/#s01-parse> for details.
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
                  type = lib.types.listOf yaml.type;
                  default = [ ];
                  description = ''
                    A list of stage s02-enrich specifications. Inside this list, you can specify Parser Whitelists.

                    See <https://docs.crowdsec.net/docs/next/log_processor/parsers/intro/#s01-parse> for details.
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

              See <https://docs.crowdsec.net/docs/next/log_processor/parsers/intro/> for details.
            '';
            default = { };
          };

          postOverflows = lib.mkOption {
            type = lib.types.submodule {
              options = {
                s01Whitelist = lib.mkOption {
                  type = lib.types.listOf yaml.type;
                  default = [ ];
                  description = ''
                    A list of stage s01-whitelist specifications. Inside this list, you can specify Postoverflows Whitelists.

                    See <https://docs.crowdsec.net/docs/next/log_processor/parsers/intro/#postoverflows> for details.
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
            type = lib.types.listOf yaml.type;
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
            type = lib.types.listOf yaml.type;
            description = ''
              A list of notifications to enable and use in your profiles.
              Note that for now, only the plugins shipped by default with CrowdSec are supported.

              See <https://docs.crowdsec.net/docs/next/local_api/notification_plugins/intro> for details.
            '';
            example = [
              {
                type = "http";
                name = "default_http_notification";
                log_level = "info";
                yaml = ''
                  {{.|toJson}}
                '';
                url = "https://example.com/hook";
                method = "POST";
              }
            ];
            default = [ ];
          };

          profiles = lib.mkOption {
            type = lib.types.listOf yaml.type;
            description = ''
              A list of profiles to enable.

              See <https://docs.crowdsec.net/u/getting_started/post_installation/profiles> for more details.
            '';
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

              See <https://docs.crowdsec.net/docs/next/log_processor/parsers/yaml/#patterns-documentation> for more details.
            '';
            default = [ ];
            example = lib.literalExpression ''
              [ (pkgs.writeTextDir "custom_service_logs" (builtins.readFile ./custom_service_logs)) ]
            '';
          };

          console = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enrollKeyFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  example = "/run/crowdsec/console_token.yaml";
                  description = ''
                    The Console Token file to use.

                    Normally you would do `cscli enroll <token>`,
                    but you can put the token in a file instead and pass the path of that file to this option.

                    The token is available by clicking the "Enroll command" button at <https://app.crowdsec.net/security-engines?distribution=linux>
                  '';
                  default = null;
                };

                configuration = lib.mkOption {
                  type = yaml.type;
                  description = ''
                    Attributes inside the console.yaml file.
                  '';
                  default = {
                    share_manual_decisions = false;
                    share_custom = false;
                    share_tainted = false;
                    share_context = false;
                  };
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
      description = ''
        Set of various configuration attributes
      '';
    };
  };
  config =
    let
      dirs = [
        config_paths.config_dir
        config_paths.data_dir
        config_paths.hub_dir
        config_paths.notification_dir
        config_paths.plugin_dir
        cfg.settings.config.crowdsec_service.acquisition_dir
        "${config_paths.config_dir}/console"
        "${config_paths.config_dir}/scenarios"
      ];

      setupScript = pkgs.writeShellApplication {
        name = "crowdsec-setup";
        runtimeInputs = [
          cfg.package
          pkgs.coreutils
        ];
        text =
          let
            argString = arg: lib.concatMapStringsSep " " lib.escapeShellArg arg;
            maybeInstall =
              x:
              lib.optionalString (
                builtins.isList cfg.hub.${x} && cfg.hub.${x} != [ ]
              ) "cscli ${lib.toLower x} install ${argString cfg.hub.${x}}";
          in
          ''

            echo "Updating hub..."

            cscli hub update

            echo "Installing resources..."

            ${maybeInstall "collections"}
            ${maybeInstall "scenarios"}
            ${maybeInstall "parsers"}
            ${maybeInstall "postoverflows"}
            ${maybeInstall "appsec-configs"}
            ${maybeInstall "appsec-rules"}

            ${lib.optionalString (cfg.settings.config.api.server.online_client.credentials_path != null) ''
              if [ ! -s "${cfg.settings.config.api.server.online_client.credentials_path}" ]; then
                echo "No local online API credentials created. Registering..."
                cscli capi register
              fi
            ''}

            ${lib.optionalString cfg.settings.config.api.server.enable ''
              if [ ! -s ${cfg.settings.config.api.client.credentials_path} ]; then
                echo "No local API credentials currently created. Generating local API credentials..."
                cscli machines add "${cfg.name}" --auto --file ${cfg.settings.config.api.client.credentials_path}
              fi
            ''}

            ${lib.optionalString (cfg.settings.console.enrollKeyFile != null) ''
              if [ -e "$CREDENTIALS_DIRECTORY/enrollKeyFile" ]; then
                echo "Enrolling to the online console..."
                cscli console enroll "$(<"$CREDENTIALS_DIRECTORY/enrollKeyFile")" --name ${cfg.name}
              fi
            ''}
            echo "Completed crowdsec setup"
          '';
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

      environment.systemPackages = [ cfg.package ];

      systemd = {
        timers.crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
          description = "Update the crowdsec hub index";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "daily";
            RandomizedDelaySec = 300;
            Persistent = "yes";
            Unit = "crowdsec-update-hub.service";
          };
        };

        services =
          let
            createServiceConfig =
              attrs:
              lib.recursiveUpdate {
                User = cfg.user;
                Group = cfg.group;
                UMask = "0077";
                DynamicUser = true;
                ReadWritePaths = dirs;
                PrivateDevices = true;
                LockPersonality = true;

                ProtectHome = true;
                ProtectHostname = "true:${cfg.name}";
                ProtectClock = true;
                ProtectKernelTunables = true;
                ProtectKernelModules = true;
                ProtectKernelLogs = true;
                ProtectControlGroups = "strict";
                ProtectProc = "invisible";

                RestrictRealtime = true;
                RestrictNamespaces = true;
                RestrictAddressFamilies = [
                  "AF_UNIX"
                  "AF_INET"
                  "AF_INET6"
                ];

                LoadCredential = lib.optional (
                  cfg.settings.console.enrollKeyFile != null
                ) "enrollKeyFile:${cfg.settings.console.enrollKeyFile}";

                SystemCallFilter = [ "@system-service" ];
                SystemCallErrorNumber = "EPERM";
                SystemCallArchitectures = "native";
              } attrs;
          in
          {
            crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
              description = "Update the crowdsec hub index";
              # for dns resolving
              wants = [ "network-online.target" ];
              after = [ "network-online.target" ];

              serviceConfig = createServiceConfig {
                Type = "oneshot";
                ExecStart = [
                  "${lib.getExe' cfg.package "cscli"} --warning hub update"
                  "${lib.getExe' cfg.package "cscli"} --warning hub upgrade"
                ];
                ExecStartPost = "+systemctl reload crowdsec.service";
              };
            };

            crowdsec-setup = {
              description = "CrowdSec setup service";
              wantedBy = [ "multi-user.target" ];
              wants = [ "network-online.target" ];
              # for dns resolving
              after = [ "network-online.target" ];
              serviceConfig = createServiceConfig {
                Type = "oneshot";
                # the notification plugins are owned by root after copying them with tmpfiles.
                # It's not possible to copy files and change the mode of the files at the same time
                ExecStartPre = "+${lib.getExe' pkgs.coreutils "chown"} -R ${cfg.user}:${cfg.group} ${config_paths.plugin_dir}";
                ExecStart = lib.getExe setupScript;
              };
            };

            crowdsec = {
              description = "CrowdSec Security Engine";
              wantedBy = [ "multi-user.target" ];
              wants = [
                "network-online.target"
                "crowdsec-setup.service"
              ];
              after = [
                "network-online.target"
                "crowdsec-setup.service"
              ];

              serviceConfig =
                let
                  crowdsec = "${lib.getExe' cfg.package "crowdsec"}";
                in
                createServiceConfig {
                  Type = "notify";
                  RestartSec = 60;

                  ProtectKernelLogs = false;

                  ReadOnlyPaths = cfg.readOnlyPaths;
                  SupplementaryGroups = cfg.extraGroups;

                  ExecStartPre = "${crowdsec} -t -error";
                  ExecStart = crowdsec;
                  ExecReload = [
                    "${crowdsec} -t -error"
                    "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID"
                  ];

                  ExecPaths = [ cfg.settings.config.config_paths.plugin_dir ];

                  Restart = "always";
                };
            };
          };

        tmpfiles.settings."10-crowdsec" =
          let
            toYaml = lib.generators.toYAML { };

            createDirectory = dirPath: {
              name = dirPath;
              value.d = {
                user = cfg.user;
                group = cfg.group;
              };
            };

            createFile = dstPath: content: {
              name = dstPath;
              value.f = {
                user = cfg.user;
                group = cfg.group;
                argument = content;
              };
            };

            createSymlink = src: dst: {
              name = dst;
              value."L+".argument = src;
            };

            createEnumeratedSymlinks =
              targetDir: attrList:
              let
                converter =
                  idx: attrList:
                  if attrList == [ ] then
                    [ ]
                  else
                    let
                      dst_path = "${targetDir}/${toString idx}-nixos-generated.yaml";

                      next_attr = builtins.head attrList;
                      rest = builtins.tail attrList;

                      entry = {
                        name = dst_path;
                        value."L+".argument = toString (yaml.generate "${toString idx}-nixos-generated.yaml" next_attr);
                      };
                    in
                    [ entry ] ++ (converter (idx + 1) rest);

              in
              converter 0 attrList;

            linkNotificationPlugin = name: {
              name = "${config_paths.plugin_dir}/notification-${name}";
              value."C+".argument = "${cfg.package}/bin/notification-${name}";
            };

            directories = map createDirectory dirs;

            files = [
              (createFile cfg.settings.config.api.server.console_path (toYaml cfg.settings.console.configuration))
              (createFile cfg.settings.config.api.server.profiles_path (
                lib.strings.concatMapStringsSep "\n---\n" toYaml cfg.settings.profiles
              ))
              (createFile config_paths.simulation_path (toYaml cfg.settings.simulation))
              (createFile "${cfg.settings.config.crowdsec_service.acquisition_dir}/0-nixos-generated.yaml" (
                lib.strings.concatMapStringsSep "\n---\n" toYaml cfg.settings.acquisitions
              ))
            ];

            notificationFiles = map linkNotificationPlugin [
              "dummy"
              "email"
              "file"
              "http"
              "sentinel"
              "slack"
              "splunk"
            ];

            enumeratedFiles = lib.lists.flatten [
              (createEnumeratedSymlinks "${config_paths.config_dir}/scenarios" cfg.settings.scenarios)
              (createEnumeratedSymlinks "${config_paths.config_dir}/parsers/s00-raw" cfg.settings.parsers.s00Raw)
              (createEnumeratedSymlinks "${config_paths.config_dir}/parsers/s01-parse" cfg.settings.parsers.s01Parse)
              (createEnumeratedSymlinks "${config_paths.config_dir}/parsers/s02-enrich" cfg.settings.parsers.s02Enrich)
              (createEnumeratedSymlinks "${config_paths.config_dir}/postoverflows/s01-whitelist" cfg.settings.postOverflows.s01Whitelist)
              (createEnumeratedSymlinks "${config_paths.config_dir}/contexts" cfg.settings.contexts)
              (createEnumeratedSymlinks config_paths.notification_dir cfg.settings.notifications)
            ];

            symlinks = [
              (createSymlink "${cfg.package}/share/crowdsec/config/detect.yaml" "${config_paths.data_dir}/detect.yaml")
              (createSymlink "${cfg.package}/share/crowdsec/config/config.yaml" "${config_paths.config_dir}/config.yaml")

              (createSymlink (toString (yaml.generate "config.yaml" cfg.settings.config)) "${config_paths.config_dir}/config.yaml.local")
            ];

            entries = directories ++ files ++ symlinks ++ enumeratedFiles ++ notificationFiles;
          in
          builtins.listToAttrs entries;
      };

      users = {
        users.${cfg.user} = {
          name = cfg.user;
          group = cfg.group;
          description = lib.mkDefault "CrowdSec service user";
          isSystemUser = true;
          extraGroups = [ "systemd-journal" ] ++ cfg.extraGroups;
        };

        groups.${cfg.group} = { };
      };
    };

  meta = {
    maintainers = with lib.maintainers; [
      M0ustach3
      tornax
      jk
    ];
  };
}
