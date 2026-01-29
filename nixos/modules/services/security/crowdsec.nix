{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.crowdsec;
  yaml = pkgs.formats.yaml { };
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "crowdsec"
      "localConfig"
    ] "Please move options from `services.crowdsec.localConfig` to `services.crowdsec.settings`.")

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
      description = "Config options for the main config file.";
      type = lib.types.submodule {
        options = {
          config = lib.mkOption {
            description = ''
              Settings for the main CrowdSec configuration file.

              Defaults are _mostly_ equal to the default linux config file: <https://github.com/crowdsecurity/crowdsec/blob/master/config/config.yaml>.

              See here for possible values: <https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#configuration-directives>.
            '';
            type = lib.types.submodule {
              freeformType = yaml.type;
              options =
                let
                  config_paths = cfg.settings.config.config_paths;
                in
                {
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
                      default = "/var/lib/crowdsec";
                      description = "This is where crowdsec is going to store data, such as files downloaded by scenarios, geolocalisation database, metabase configuration database, or even SQLite database.";
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

                    plugin_dir = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.data_dir}/plugins";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/plugins";
                      description = "Path to directory where the plugin binaries/scripts are located.";
                    };

                    notification_dir = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.config_dir}/notifications";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_dir}/notifications";
                      description = "Path to directory where configuration files for notification plugins are kept.";
                    };

                    simulation_path = lib.mkOption {
                      type = lib.types.path;
                      default = yaml.generate "simulation.yaml" cfg.settings.simulation;
                      defaultText = "Path to the nixos generated file.";
                      description = ''
                        NOTE: This file is generated from `config.services.crowdsec.settings.simulation`.
                        If you change this path then `config.services.crowdsec.settings.simulation` will be ignored so you have to
                        write the content this file on your own.
                      '';
                    };

                    pattern_dir = lib.mkOption {
                      type = lib.types.path;
                      default = pkgs.buildPackages.symlinkJoin {
                        name = "crowdsec-patterns";
                        paths = [
                          cfg.settings.patterns
                          "${lib.attrsets.getOutput "out" cfg.package}/share/crowdsec/config/patterns/"
                        ];
                      };
                      defaultText = ''
                        A directory which contains the patterns of `config.services.crowdsec.settings.patterns` and the patterns
                        from this directory: <https://github.com/crowdsecurity/crowdsec/tree/master/config/patterns>.
                      '';
                      description = "Path to directory where pattern files are located.";
                    };
                  };

                  db_config = {
                    db_path = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.data_dir}/crowdsec.db";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/crowdsec.db";
                      description = "The path to the database file (only if the type of database is `sqlite`) or path to socket file (only if the type of database is `mysql|pgx`)";
                    };
                  };

                  crowdsec_service = {
                    acquisition_dir = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.config_dir}/acquis.d";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.config_dir}/acquis.d";
                      description = ''
                        Path to a directory where each yaml is considered as a acquisition configuration file containing logs that needs to be read.
                        If both acquisition_dir and acquisition_path are specified, the entries are merged alltogether.
                      '';
                    };
                  };

                  api = {
                    client.credentials_path = lib.mkOption {
                      type = lib.types.path;
                      default = "${config_paths.data_dir}/local_api_credentials.yaml";
                      defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/local_api_credentials.yaml";
                      description = "Path to the credential files (contains API url + login/password).";
                    };

                    server = {
                      enable = lib.mkOption {
                        type = lib.types.bool;
                        default = true;
                        description = "Enable or disable the CrowdSec Local API (`true` by default).";
                      };

                      console_path = lib.mkOption {
                        type = lib.types.path;
                        default = "${config_paths.data_dir}/console.yaml";
                        defaultText = lib.literalExpression "\${config.services.crowdsec.settings.config.config_paths.data_dir}/console.yaml";
                        description = "The path to the console configuration.";
                      };

                      online_client.credentials_path = lib.mkOption {
                        type = lib.types.nullOr lib.types.path;
                        default = null;
                        description = "Path to a file containing credentials for the Central API.";
                      };
                    };
                  };

                  cscli.hub_branch = lib.mkOption {
                    type = lib.types.nonEmptyStr;
                    default = "master";
                    description = ''
                      The git branch on which cscli is going to fetch configurations.

                      See <https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#hub_branch> for more information.
                    '';
                  };

                  prometheus = {
                    listen_port = lib.mkOption {
                      type = lib.types.port;
                      default = 6060;
                      description = "Prometheus listen port.";
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
              A list of notifications to enable and use in your profiles. Note that for now, only the plugins shipped by default with CrowdSec are supported.

              See <https://docs.crowdsec.net/docs/next/local_api/notification_plugins/intro> for details.
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

              See <https://docs.crowdsec.net/docs/next/log_processor/parsers/format/#patterns-documentation> for more details.
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

                    Normally you'd have to do `cscli enroll <token>`. You can put this `<token>` in a file instead and pass a path to this file into this option.
                  '';
                  default = null;
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
      cscli = pkgs.writeShellScriptBin "cscli" ''
        ${lib.getExe' cfg.package "cscli"} -c="${cfg.settings.config.config_paths.config_dir}/config.yaml" -c="${cfg.settings.config.config_paths.config_dir}/config.yaml.local" "$@"
      '';

      setupScript = pkgs.writeShellApplication {
        name = "crowdsec-setup";
        runtimeInputs = [ cscli ];
        text =
          let
            argString = arg: lib.concatMapStringsSep " " lib.escapeShellArg arg;
            maybeInstall =
              x:
              lib.optionalString (
                builtins.isList cfg.hub.${x} && cfg.hub.${x} != [ ]
              ) "cscli ${lib.toLower x} install ${argString cfg.hub.${x}}";

            installNotificationPlugin = name: ''
              install -o ${cfg.user} -g ${cfg.group} -m 0750 -D ${cfg.package}/libexec/crowdsec/plugins/${name} ${cfg.settings.config.config_paths.data_dir}/plugins/${name}
            '';
          in
          ''
            cscli hub update

            ${maybeInstall "collections"}
            ${maybeInstall "scenarios"}
            ${maybeInstall "parsers"}
            ${maybeInstall "postoverflows"}
            ${maybeInstall "appsec-configs"}
            ${maybeInstall "appsec-rules"}

            # to be able to create notifications
            ${installNotificationPlugin "notification-dummy"}
            ${installNotificationPlugin "notification-email"}
            ${installNotificationPlugin "notification-file"}
            ${installNotificationPlugin "notification-http"}
            ${installNotificationPlugin "notification-sentinel"}
            ${installNotificationPlugin "notification-slack"}
            ${installNotificationPlugin "notification-splunk"}

            ${lib.optionalString cfg.settings.config.api.server.enable ''
              if [ ! -f ${cfg.settings.config.api.client.credentials_path} ]; then
                echo "No local API credentials currently created. Generating local API credentials..."
                cscli machines add "${cfg.name}" --auto --file ${cfg.settings.config.api.client.credentials_path}
              fi
            ''}

            ${lib.optionalString (cfg.settings.config.api.server.online_client.credentials_path != null) ''
              if [ -e "${cfg.settings.config.api.server.online_client.credentials_path}" ]; then
                cscli capi register
              fi
            ''}

            ${lib.optionalString (cfg.settings.console.enrollKeyFile != null) ''
              if [ -e "$CREDENTIALS_DIRECTORY/enrollKeyFile" ]; then
                cscli console enroll "$CREDENTIALS_DIRECTORY/enrollKeyFile" --name ${cfg.name}
              fi
            ''}
          '';
      };

      # for files and dirs belonging to crowdsec
      entry_permissions = {
        user = cfg.user;
        group = cfg.group;
        mode = "0750";
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
        ]
        ++ lib.optionals (builtins.hasAttr "daemonize" cfg.settings.config.common) [
          "[`services.crowdsec.settings.config.common.daemonize`]: It's deprecated. See <https://doc.crowdsec.net/u/bouncers/firewall/#daemonize>"
        ];

      assertions = [
        # `cfg.settings.config.api.server` needs to be set up if the user wants
        # to pull things from the hub. See:
        # https://github.com/NixOS/nixpkgs/pull/446307#issuecomment-3533763091
        {
          assertion =
            let
              usesHub =
                let
                  cfg-hub-lists = builtins.filter (value: builtins.typeOf value == "list") (
                    builtins.attrValues cfg.hub
                  );
                  lists-are-not-empty = builtins.all (list: list != [ ]) cfg-hub-lists;
                in
                lists-are-not-empty;

              onlineApiCredentialsAreSet =
                builtins.hasAttr "api" cfg.settings.config
                && builtins.hasAttr "server" cfg.settings.config.api
                && builtins.hasAttr "online_client" cfg.settings.config.api.server
                && builtins.hasAttr "credentials_path" cfg.settings.config.api.server.online_client;
            in
            !usesHub || (usesHub && onlineApiCredentialsAreSet);

          message = "`config.services.crowdsec.settings.config.api.server.online_client.credentials_path` needs to be set.";
        }
      ];

      environment = {
        systemPackages =
          let
            cscliWrapper = pkgs.writeShellScriptBin "cscli" ''
              exec systemd-run \
                --quiet \
                --pty \
                --wait \
                --collect \
                --pipe \
                --property=User=${cfg.user} \
                --property=Group=${cfg.group} \
                --property=DynamicUser=true \
                --property=StateDirectory="crowdsec crowdsec/hub" \
                --property=StateDirectoryMode="0750" \
                --property=ConfigurationDirectory="crowdsec crowdsec/acquis.d" \
                --property=ConfigurationDirectoryMode="0750" \
                -- \
                ${lib.getExe cscli} "$@"
            '';
          in
          [ cscliWrapper ];

        etc =
          let
            config_dir = "crowdsec";

            start = lib.mapAttrs (name: value: lib.mergeAttrs value entry_permissions) {
              "${config_dir}/config.yaml".source = "${cfg.package}/share/crowdsec/config/config.yaml";
              "${config_dir}/config.yaml.local".source = yaml.generate "config.yaml.local" cfg.settings.config;
              "${config_dir}/acquis.d/00-nixos-generated.yaml".source = pkgs.writeText "aquisitions.yaml" ''
                ---
                ${lib.strings.concatMapStringsSep "\n---\n" (lib.generators.toYAML { }) cfg.settings.acquisitions}
                ---
              '';
              "${config_dir}/profiles.yaml".source = pkgs.writeText "profiles.yaml" ''
                ---
                ${lib.strings.concatMapStringsSep "\n---\n" (lib.generators.toYAML { }) cfg.settings.profiles}
                ---
              '';
            };

            attrListToEntries =
              attrList: target_dir: generated_file_name:
              let
                file_paths = map (yaml.generate generated_file_name) attrList;

                # Example usage:
                #   enumerated_entries 0 ["path1" "path2"]
                #   =>
                #     [
                #         { name = "${target_dir}/0-nixos-generated.yaml"; source = path1; }
                #         { name = "${target_dir}/1-nixos-generated.yaml"; source = path2; }
                #     ]
                enumerated_entries =
                  idx: paths:
                  if paths == [ ] then
                    [ ]
                  else
                    let
                      dst_path = "${target_dir}/${builtins.toString idx}-nixos-generated.yaml";

                      src_path = builtins.head paths;
                      rest = builtins.tail paths;

                      entry = {
                        name = dst_path;

                        value = lib.mergeAttrs entry_permissions {
                          source = src_path;
                        };
                      };
                    in
                    [ entry ] ++ (enumerated_entries (idx + 1) rest);
              in
              builtins.listToAttrs (enumerated_entries 0 file_paths);

          in
          builtins.foldl' lib.mergeAttrs start [
            (attrListToEntries cfg.settings.scenarios "${config_dir}/scenarios" "scenario.yaml")
            (attrListToEntries cfg.settings.parsers.s00Raw "${config_dir}/parsers/s00-raw"
              "parsers-s00-raw.yaml"
            )
            (attrListToEntries cfg.settings.parsers.s01Parse "${config_dir}/parsers/s01-parse"
              "parsers-s01-parse.yaml"
            )
            (attrListToEntries cfg.settings.parsers.s02Enrich "${config_dir}/parsers/s02-enrich"
              "parsers-s02-enrich.yaml"
            )
            (attrListToEntries cfg.settings.postOverflows.s01Whitelist
              "${config_dir}/postoverflows/s01-whitelist"
              "postoverflows-s01-whitelist.yaml"
            )
            (attrListToEntries cfg.settings.contexts "${config_dir}/contexts" "context.yaml")
            (attrListToEntries cfg.settings.notifications "${config_dir}/notifications" "notification.yaml")
          ];
      };

      systemd =
        let
          createServiceConfig =
            attrs:
            lib.recursiveUpdate {
              User = cfg.user;
              Group = cfg.group;
              UMask = "0077";

              DynamicUser = true;
              ProtectHome = true;
              PrivateDevices = true;
              ProtectHostname = "true:${cfg.name}";
              ProtectClock = true;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectKernelLogs = true;
              ProtectControlGroups = "strict";
              ProtectProc = "invisible";

              LockPersonality = true;
              RestrictRealtime = true;
              RestrictNamespaces = true;

              LoadCredential = lib.optional (
                cfg.settings.console.enrollKeyFile != null
              ) "enrollKeyFile:${cfg.settings.console.enrollKeyFile}";

              SystemCallFilter = [ "@system-service" ];

              SystemCallErrorNumber = "EPERM";
              SystemCallArchitectures = "native";
              RestrictAddressFamilies = [
                "AF_UNIX"
                "AF_INET"
                "AF_INET6"
              ];

              StateDirectory = "crowdsec crowdsec/hub";
              StateDirectoryMode = "0750";
              ConfigurationDirectory = "crowdsec crowdsec/acquis.d";
              ConfigurationDirectoryMode = "0750";
            } attrs;
        in
        {
          packages = [ cfg.package ];

          timers.crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
            description = "Update the crowdsec hub index";
            wantedBy = [ "timers.target" ];
            after = [ ];
            timerConfig = {
              OnCalendar = "daily";
              RandomizedDelaySec = 300;
              Persistent = "yes";
              Unit = "crowdsec-update-hub.service";
            };
          };

          tmpfiles.settings.crowdsec = {
            # Reason(#1): `environment.etc` is faster than `systemd.services.crowdsec.serviceConfig.ConfigurationDirectoryMode`
            # and creates the directory with 0755 mode.
            #
            # For whatever reason this doesn't really work.
            # The user needs to execute `sudo systemd-tmpfiles --create` manually after crowdsec has started to fix the permissions...
            "${cfg.settings.config.config_paths.config_dir}".d = entry_permissions;
            "${cfg.settings.config.crowdsec_service.acquisition_dir}".d = entry_permissions;
          };

          services = {
            crowdsec-update-hub = lib.mkIf (cfg.autoUpdateService) {
              description = "Update the crowdsec hub index";

              serviceConfig = createServiceConfig {
                Type = "oneshot";
                ExecStart = [
                  "${lib.getExe cscli} --warning hub update"
                  "${lib.getExe cscli} --warning hub upgrade"
                ];
                ExecStartPost = "+systemctl reload crowdsec.service";
              };
            };

            crowdsec-setup = {
              description = "CrowdSec setup service";
              wantedBy = [ "multi-user.target" ];
              wants = [ "network-online.target" ];
              before = [ "crowdsec.service" ];
              serviceConfig = createServiceConfig {
                Type = "oneshot";
                ExecStart = lib.getExe setupScript;
              };
            };

            crowdsec = {
              description = "CrowdSec Security Engine";
              wantedBy = [ "multi-user.target" ];
              wants = [ "network-online.target" ];
              after = [
                "network-online.target"
                "crowdsec-setup.service"

                # See Reason(#1)
                "systemd-tmpfiles-setup.service"
                "systemd-tmpfiles-setup-dev-early.service"
                "systemd-tmpfiles-setup-dev.service"
                "systemd-tmpfiles-clean.service"
                "systemd-tmpfiles-clean.timer"
              ];

              environment = {
                LC_ALL = "C";
                LANG = "C";
              };

              serviceConfig = createServiceConfig {
                Type = "notify";
                RestartSec = 60;

                ProtectKernelLogs = false;

                ExecStart = "${lib.getExe' cfg.package "crowdsec"} -c ${cfg.settings.config.config_paths.config_dir}/config.yaml -info";
                ExecStartPre = "${lib.getExe' cfg.package "crowdsec"} -c ${cfg.settings.config.config_paths.config_dir}/config.yaml -t -error";
              };
            };
          };
        };

      users.users.${cfg.user} = {
        name = cfg.user;
        description = lib.mkDefault "CrowdSec service user";
        isSystemUser = true;
        group = cfg.group;
        extraGroups = [ "systemd-journal" ];
      };

      users.groups.${cfg.group} = lib.mapAttrs (name: lib.mkOptionDefault) { };

      networking.firewall.allowedTCPPorts =
        let
          parsePortFromURLOption =
            url: option:
            builtins.addErrorContext "extracting a port from URL: `${option}` requires a port to be specified, but we failed to parse a port from '${url}'" (
              lib.strings.toInt (lib.last (lib.strings.splitString ":" url))
            );
        in
        lib.mkIf cfg.openFirewall [
          cfg.settings.config.prometheus.listen_port
          (parsePortFromURLOption cfg.settings.config.api.server.listen_uri "config.services.crowdsec.settings.config.api.server.listen_uri")
        ];
    };

  meta = {
    maintainers = with lib.maintainers; [
      M0ustach3
      tornax
      jk
    ];
  };
}
