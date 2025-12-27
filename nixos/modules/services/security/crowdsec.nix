{
  config,
  pkgs,
  lib,
  ...
}:
let
  yaml = pkgs.formats.yaml { };
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
            example = "master";
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
              Settings for the main CrowdSec configuration file.

              Defaults are _mostly_ equal to the default linux config file: <https://github.com/crowdsecurity/crowdsec/blob/master/config/config.yaml>.

              See here for possible values: <https://docs.crowdsec.net/docs/configuration/crowdsec_configuration/#configuration-directives>.
            '';
            type = lib.types.submodule {
              freeformType = yaml.type;
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

              See <https://docs.crowdsec.net/docs/data_sources/intro> for details.
            '';
          };

          scenarios = lib.mkOption {
            type = lib.types.listOf yaml.type;
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
                  type = lib.types.listOf yaml.type;
                  default = [ ];
                  description = ''
                    A list of stage s00-raw specifications. Most of the time, those are already included in the hub, but are presented here anyway.

                    See <https://docs.crowdsec.net/docs/parsers/intro> for details.
                  '';
                };
                s01Parse = lib.mkOption {
                  type = lib.types.listOf yaml.type;
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
                  type = lib.types.listOf yaml.type;
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
                  type = lib.types.listOf yaml.type;
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
            type = lib.types.listOf yaml.type;
            description = ''
              A list of profiles to enable.

              See <https://docs.crowdsec.net/docs/profiles/intro> for more details.
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
                  type = yaml.type;
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

      cscli = pkgs.writeShellScriptBin "cscli" ''
        set -euo pipefail
        sudo=exec
        if [ "$USER" != "${cfg.user}" ]; then
          ${
            if config.security.sudo.enable || config.security.sudo-rs.enable then
              "sudo='exec ${config.security.wrapperDir}/sudo -u ${cfg.user}'"
            else
              ">&2 echo 'Aborting, cscli must be run as user `${cfg.user}`!'; exit 2"
          }
        fi
        $sudo ${lib.getExe' cfg.package "cscli"} -c=${"${cfg.settings.general.config_paths.config_dir}/config.yaml"} "$@"
      '';

      scriptArray = [
        "${lib.getExe cscli} hub update"
      ]
      ++ lib.optional cfg.settings.general.api.server.enable ''
        if [ ! -f ${cfg.settings.general.api.client.credentials_path} ]; then
          echo "No local API credentials currently created. Generating local API credentials..."
          ${lib.getExe cscli} machines add nixos-generated --auto --file ${cfg.settings.general.api.client.credentials_path}
        fi
      ''
      ++
        lib.optional (cfg.hub.collections != [ ])
          "${lib.getExe cscli} collections install ${
            lib.strings.concatMapStringsSep " " lib.escapeShellArg cfg.hub.collections
          }"
      ++
        lib.optional (cfg.hub.scenarios != [ ])
          "${lib.getExe cscli} scenarios install ${
            lib.strings.concatMapStringsSep " " lib.escapeShellArg cfg.hub.scenarios
          }"
      ++
        lib.optional (cfg.hub.parsers != [ ])
          "${lib.getExe cscli} parsers install ${
            lib.strings.concatMapStringsSep " " lib.escapeShellArg cfg.hub.parsers
          }"
      ++
        lib.optional (cfg.hub.postOverflows != [ ])
          "${lib.getExe cscli} postoverflows install ${
            lib.strings.concatMapStringsSep " " lib.escapeShellArg cfg.hub.postOverflows
          }"
      ++
        lib.optional (cfg.hub.appSecConfigs != [ ])
          "${lib.getExe cscli} appsec-configs install ${
            lib.strings.concatMapStringsSep " " lib.escapeShellArg cfg.hub.appSecConfigs
          }"
      ++
        lib.optional (cfg.hub.appSecRules != [ ])
          "${lib.getExe cscli} appsec-rules install ${
            lib.strings.concatMapStringsSep " " lib.escapeShellArg cfg.hub.appSecRules
          }"
      ++ lib.optional (cfg.settings.general.api.server.online_client.credentials_path != null) ''
        if ! grep -q password "${cfg.settings.general.api.server.online_client.credentials_path}";  then
          ${lib.getExe cscli} capi register
        fi
      ''
      ++ lib.optional (cfg.settings.console.tokenFile != null) ''
        ${lib.getExe cscli} console enroll "$(cat ${cfg.settings.console.tokenFile})" --name ${cfg.name}
      '';

      setupScript = pkgs.writeShellApplication {
        name = "crowdsec-setup";

        runtimeInputs =
          with pkgs;
          [
            coreutils
            gnugrep
          ]
          ++ [
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

      assertions = [
        # `cfg.settings.general.api.server` needs to be set up if the user wants
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
                builtins.hasAttr "api" cfg.settings.general
                && builtins.hasAttr "server" cfg.settings.general.api
                && builtins.hasAttr "online_client" cfg.settings.general.api.server
                && builtins.hasAttr "credentials_path" cfg.settings.general.api.server.online_client;
            in
            !usesHub || (usesHub && onlineApiCredentialsAreSet);

          message = "`config.services.crowdsec.settings.general.api.server.online_client.credentials_path` needs to set.";
        }
      ];

      services.crowdsec.settings.general = rec {
        common = {
          daemonize = false;
          log_media = "stdout";
        };
        config_paths = {
          config_dir = "/etc/crowdsec";
          data_dir = "/var/lib/crowdsec";
          hub_dir = "${config_paths.data_dir}/hub";
          index_path = "${config_paths.hub_dir}/.index.json";
          notification_dir = "${config_paths.config_dir}/notifications";
          plugin_dir = "${config_paths.config_dir}/plugins";

          simulation_path = yaml.generate "simulation.yaml" cfg.settings.simulation;

          pattern_dir = pkgs.buildPackages.symlinkJoin {
            name = "crowdsec-patterns";
            paths = [
              cfg.settings.patterns
              "${lib.attrsets.getOutput "out" cfg.package}/share/crowdsec/config/patterns/"
            ];
          };
        };
        crowdsec_service = lib.mkDefault {
          enable = lib.mkDefault true;
          acquisition_path = "${config_paths.config_dir}/acquis.yaml";
          acquisition_dir = "${config_paths.config_dir}/acquis.d";
          parser_routines = lib.mkDefault 1;
        };
        db_config = lib.mkDefault {
          type = lib.mkDefault "sqlite";
          db_path = lib.mkDefault "${config_paths.data_dir}/crowdsec.db";
          use_wal = lib.mkDefault true;
        };
        plugin_config = lib.mkDefault {
          user = lib.mkDefault "nobody";
          group = lib.mkDefault "nogroup";
        };
        api = {
          client = {
            insecure_skip_verify = lib.mkDefault false;
            credentials_path = lib.mkDefault "${config_paths.data_dir}/local_api_credentials.yaml";
          };
          server = {
            enable = lib.mkDefault true;
            listen_uri = lib.mkDefault "127.0.0.1:8080";

            profiles_path = "${config_paths.config_dir}/profiles.yaml";
            console_path = "${config_paths.data_dir}/console.yaml";

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
          enabled = lib.mkDefault true;
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

        etc =
          let
            config_dir = "crowdsec";

            start = {
              "${config_dir}/config.yaml".source = yaml.generate "config.yaml" cfg.settings.general;
              "${config_dir}/acquis.d/00-nixos-generated.yaml".source = pkgs.writeText "aquisitions.yaml" ''
                ---
                ${lib.strings.concatMapStringsSep "\n---\n" builtins.toJSON cfg.settings.acquisitions}
                ---
              '';
              "${config_dir}/console.yaml".source =
                yaml.generate "console.yaml" cfg.settings.console.configuration;
              "${config_dir}/profiles.yaml".source = pkgs.writeText "profiles.yaml" ''
                ---
                ${lib.strings.concatMapStringsSep "\n---\n" builtins.toJSON cfg.settings.profiles}
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
                      dst_path = "${target_dir}/${idx}-nixos-generated.yaml";

                      src_path = builtins.head paths;
                      rest = builtins.tail paths;

                      entry = {
                        name = dst_path;

                        value = {
                          source = src_path;
                        };
                      };
                    in
                    [ entry ] ++ (enumerated_entries (idx + 1) rest);
              in
              builtins.listToAttrs (enumerated_entries 0 file_paths);
          in
          (builtins.foldl' lib.mergeAttrs start [
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
          ]);
      };

      systemd = {
        packages = [ cfg.package ];

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

        services = {

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

              StateDirectory = "crowdsec";
              StateDirectoryMode = "0750";
              ConfigurationDirectory = "crowdsec";
              ConfigurationDirectoryMode = "0755";

              ExecStart = "${lib.getExe cscli} --error hub update";
              ExecStartPost = "systemctl reload crowdsec.service";
            };
          };

          crowdsec = {
            description = "CrowdSec agent";
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
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
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;

              StateDirectory = "crowdsec crowdsec/hub";
              StateDirectoryMode = "0750";
              ConfigurationDirectory = "crowdsec crowdsec/acquis.d";
              ConfigurationDirectoryMode = "0755";

              ExecReload = [
                " " # This is needed to clear the ExecReload definitions from upstream
              ];
              ExecStart = [
                # This is needed to clear the ExecStart definitions from upstream
                # Service will fail because there will be more than just one `ExecStart` for whatever reason
                " "
                "${lib.getExe' cfg.package "crowdsec"} -info"
              ];
              ExecStartPre = [
                " "
                "${lib.getExe setupScript}"
                "${lib.getExe' cfg.package "crowdsec"} -t -error"
              ];
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

      users.groups.${cfg.group} = lib.mapAttrs (name: lib.mkDefault) { };

      networking.firewall.allowedTCPPorts =
        let
          parsePortFromURLOption =
            url: option:
            builtins.addErrorContext "extracting a port from URL: `${option}` requires a port to be specified, but we failed to parse a port from '${url}  '" (
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
