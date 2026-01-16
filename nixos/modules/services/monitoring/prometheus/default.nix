{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkChangedOptionModule
    mkIf
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    types
    ;

  yaml = pkgs.formats.yaml { };
  cfg = config.services.prometheus;
  checkConfigEnabled =
    (lib.isBool cfg.checkConfig && cfg.checkConfig) || cfg.checkConfig == "syntax-only";

  workingDir = "/var/lib/" + cfg.stateDir;

  triggerReload = pkgs.writeShellScriptBin "trigger-reload-prometheus" ''
    PATH="${lib.makeBinPath (with pkgs; [ systemd ])}"
    if systemctl -q is-active prometheus.service; then
      systemctl reload prometheus.service
    fi
  '';

  reload = pkgs.writeShellScriptBin "reload-prometheus" ''
    PATH="${
      lib.makeBinPath (
        with pkgs;
        [
          systemd
          coreutils
          gnugrep
        ]
      )
    }"
    cursor=$(journalctl --show-cursor -n0 | grep -oP "cursor: \K.*")
    kill -HUP $MAINPID
    journalctl -u prometheus.service --after-cursor="$cursor" -f \
      | grep -m 1 "Completed loading of configuration file" > /dev/null
  '';

  # a wrapper that verifies that the configuration is valid
  promtoolCheck =
    name: file:
    if checkConfigEnabled then
      pkgs.runCommand "${name}-checked.yml"
        {
          preferLocalBuild = true;
          nativeBuildInputs = [ cfg.package.cli ];
        }
        ''
          ln -s ${file} $out
          promtool check config ${lib.optionalString (cfg.checkConfig == "syntax-only") "--syntax-only"} $out
        ''
    else
      file;

  generatedPrometheusYml = yaml.generate "prometheus.yml" cfg.settings;

  prometheusYml =
    let
      yml =
        if cfg.configText != null then
          pkgs.writeText "prometheus.yml" cfg.configText
        else
          generatedPrometheusYml;
    in
    promtoolCheck "prometheus.yml" yml;

  cmdlineArgs =
    cfg.extraFlags
    ++ [
      "--config.file=${if cfg.enableReload then "/etc/prometheus/prometheus.yaml" else prometheusYml}"
      "--web.listen-address=${cfg.listenAddress}:${toString cfg.port}"
    ]
    ++ (
      if cfg.enableAgentMode then
        [
          "--enable-feature=agent"
        ]
      else
        [
          "--alertmanager.notification-queue-capacity=${toString cfg.alertmanagerNotificationQueueCapacity}"
          "--storage.tsdb.path=${workingDir}/data/"
        ]
    )
    ++ lib.optional (cfg.webExternalUrl != null) "--web.external-url=${cfg.webExternalUrl}"
    ++ lib.optional (cfg.webConfigFile != null) "--web.config.file=${cfg.webConfigFile}";

  #
  # Config types: helper functions
  #

  mkDefOpt =
    type: defaultStr: description:
    mkOpt type (
      description
      + ''

        Defaults to ````${defaultStr}```` in prometheus
        when set to `null`.
      ''
    );

  mkOpt =
    type: description:
    mkOption {
      type = types.nullOr type;
      default = null;
      description = description;
    };
in
{

  imports = [
    (mkRenamedOptionModule [ "services" "prometheus2" ] [ "services" "prometheus" ])
    (mkRemovedOptionModule [ "services" "prometheus" "environmentFile" ]
      "It has been removed since it was causing issues (https://github.com/NixOS/nixpkgs/issues/126083) and Prometheus now has native support for secret files, i.e. `basic_auth.password_file` and `authorization.credentials_file`."
    )
    (mkRemovedOptionModule [
      "services"
      "prometheus"
      "alertmanagerTimeout"
    ] "Deprecated upstream and no longer had any effect")
    (mkRenamedOptionModule
      [ "services" "prometheus" "globalConfig" ]
      [ "services" "prometheus" "settings" "global" ]
    )
    (mkRenamedOptionModule
      [ "services" "prometheus" "scrapeConfigs" ]
      [ "services" "prometheus" "settings" "scrape_configs" ]
    )
    (mkRenamedOptionModule
      [ "services" "prometheus" "remoteWrite" ]
      [ "services" "prometheus" "settings" "remote_write" ]
    )
    (mkRenamedOptionModule
      [ "services" "prometheus" "remoteRead" ]
      [ "services" "prometheus" "settings" "remote_read" ]
    )
    (mkRenamedOptionModule
      [ "services" "prometheus" "alertmanagers" ]
      [ "services" "prometheus" "settings" "alerting" "alertmanagers" ]
    )
    (mkRenamedOptionModule
      [ "services" "prometheus" "retentionTime" ]
      [
        "services"
        "prometheus"
        "settings"
        "storage"
        "tsdb"
        "retention"
        "time"
      ]
    )
    (mkRenamedOptionModule
      [ "services" "prometheus" "ruleFiles" ]
      [ "services" "prometheus" "settings" "rule_files" ]
    )
    (mkChangedOptionModule
      [ "services" "prometheus" "rules" ]
      [ "services" "prometheus" "settings" "rule_files" ]
      (
        config:
        lib.optional (lib.length config.services.prometheus.rules != 0) (
          pkgs.writeText "prometheus.rules" (lib.concatStringsSep "\n" config.services.prometheus.rules)
        )
      )
    )
  ];

  options.services.prometheus = {

    enable = mkEnableOption "Prometheus monitoring daemon";

    package = mkPackageOption pkgs "prometheus" { };

    port = mkOption {
      type = types.port;
      default = 9090;
      description = ''
        Port to listen on.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Address to listen on for the web interface, API, and telemetry.
      '';
    };

    stateDir = mkOption {
      type = types.str;
      default = "prometheus2";
      description = ''
        Directory below `/var/lib` to store Prometheus metrics data.
        This directory will be created automatically using systemd's StateDirectory mechanism.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra commandline options when launching Prometheus.
      '';
    };

    enableReload = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Reload prometheus when configuration file changes (instead of restart).

        The following property holds: switching to a configuration
        (`switch-to-configuration`) that changes the prometheus
        configuration only finishes successfully when prometheus has finished
        loading the new configuration.
      '';
    };

    enableAgentMode = mkEnableOption "agent mode";

    configText = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        If non-null, this option defines the text that is written to
        prometheus.yml. If null, the contents of prometheus.yml is generated
        from the structured {option}`settings` options.
      '';
    };

    settings = mkOption {
      description = ''
        Configuration for Prometheus.

        See the [Prometheus configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
        for a complete list of available parameters.
      '';
      default = { };

      type = types.submodule {
        freeformType = yaml.type;

        options = {
          global = mkOption {
            description = ''
              Global configuration that specifies parameters that are valid in all other configuration contexts,
              and also serve as defaults for other configuration sections.

              See the [Prometheus configuration file documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file)
              for a complete list of available parameters.
            '';
            default = { };
            type = types.submodule {
              freeformType = yaml.type;
              options = {
                scrape_interval = mkDefOpt types.str "1m" ''
                  How frequently to scrape targets by default.
                '';

                evaluation_interval = mkDefOpt types.str "1m" ''
                  How frequently to evaluate rules by default.
                '';
              };
            };
          };

          scrape_configs = mkOption {
            description = ''
              A list of scrape configurations.

              Specifies a set of targets and parameters describing how to scrape them.

              See the [Prometheus `<scrape_config>` documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)
              for a complete list of available parameters.
            '';
            default = [ ];
            type = types.listOf (
              types.submodule {
                freeformType = yaml.type;
                options = {
                  job_name = mkOption {
                    type = types.str;
                    description = "The job name assigned to scraped metrics by default.";
                  };

                  scrape_interval = mkOpt types.str ''
                    How frequently to scrape targets from this job. Defaults to the
                    globally configured default.
                  '';

                  static_configs = mkOption {
                    description = ''
                      A list of targets and a common label set for them.
                      It is the canonical way to specify static targets in a scrape configuration.

                      See the [Prometheus `<static_config>` documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#static_config) a list of targets and a common label set for them. It is the canonical way to specify static targets in a scrape configuration.)
                      for a complete list of available parameters.
                    '';
                    default = null;
                    type = types.nullOr (
                      types.listOf (
                        types.submodule {
                          freeformType = yaml.type;
                          options = {
                            targets = mkOpt (types.listOf types.str) ''
                              The targets specified by the static config.
                            '';
                            labels = mkOpt (types.attrsOf types.str) ''
                              Labels assigned to all metrics scraped from the targets.
                            '';
                          };
                        }
                      )
                    );
                  };
                };
              }
            );
          };
        };
      };
    };

    alertmanagerNotificationQueueCapacity = mkOption {
      type = types.int;
      default = 10000;
      description = ''
        The capacity of the queue for pending alert manager notifications.
      '';
    };

    webExternalUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "https://example.com/";
      description = ''
        The URL under which Prometheus is externally reachable (for example,
        if Prometheus is served via a reverse proxy).
      '';
    };

    webConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specifies which file should be used as web.config.file and be passed on startup.
        See <https://prometheus.io/docs/prometheus/latest/configuration/https/> for valid options.
      '';
    };

    checkConfig = mkOption {
      type = with types; either bool (enum [ "syntax-only" ]);
      default = true;
      example = "syntax-only";
      description = ''
        Check configuration with `promtool check`. The call to `promtool` is
        subject to sandboxing by Nix.

        If you use credentials stored in external files
        (`password_file`, `bearer_token_file`, etc),
        they will not be visible to `promtool`
        and it will report errors, despite a correct configuration.
        To resolve this, you may set this option to `"syntax-only"`
        in order to only syntax check the Prometheus configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (
        let
          # Match something with dots (an IPv4 address) or something ending in
          # a square bracket (an IPv6 addresses) followed by a port number.
          legacy = builtins.match "(.*\\..*|.*]):([[:digit:]]+)" cfg.listenAddress;
        in
        {
          assertion = legacy == null;
          message = ''
            Do not specify the port for Prometheus to listen on in the
            listenAddress option; use the port option instead:
              services.prometheus.listenAddress = ${builtins.elemAt legacy 0};
              services.prometheus.port = ${builtins.elemAt legacy 1};
          '';
        }
      )
    ];

    users.groups.prometheus.gid = config.ids.gids.prometheus;
    users.users.prometheus = {
      description = "Prometheus daemon user";
      uid = config.ids.uids.prometheus;
      group = "prometheus";
    };
    environment.etc."prometheus/prometheus.yaml" = mkIf cfg.enableReload {
      source = prometheusYml;
    };
    systemd.services.prometheus = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart =
          "${lib.getExe cfg.package}"
          + lib.optionalString (lib.length cmdlineArgs != 0) (
            " \\\n  " + lib.concatStringsSep " \\\n  " cmdlineArgs
          );
        ExecReload = mkIf cfg.enableReload "+${reload}/bin/reload-prometheus";
        User = "prometheus";
        Restart = "always";
        RuntimeDirectory = "prometheus";
        RuntimeDirectoryMode = "0700";
        WorkingDirectory = workingDir;
        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "/dev/null rw" ];
        DevicePolicy = "strict";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
    # prometheus-config-reload will activate after prometheus. However, what we
    # don't want is that on startup it immediately reloads prometheus because
    # prometheus itself might have just started.
    #
    # Instead we only want to reload prometheus when the config file has
    # changed. So on startup prometheus-config-reload will just output a
    # harmless message and then stay active (RemainAfterExit).
    #
    # Then, when the config file has changed, switch-to-configuration notices
    # that this service has changed (restartTriggers) and needs to be reloaded
    # (reloadIfChanged). The reload command then reloads prometheus.
    systemd.services.prometheus-config-reload = mkIf cfg.enableReload {
      wantedBy = [ "prometheus.service" ];
      after = [ "prometheus.service" ];
      reloadIfChanged = true;
      restartTriggers = [ prometheusYml ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutSec = 60;
        ExecStart = "${pkgs.logger}/bin/logger 'prometheus-config-reload will only reload prometheus when reloaded itself.'";
        ExecReload = [ "${triggerReload}/bin/trigger-reload-prometheus" ];
      };
    };
  };
}
