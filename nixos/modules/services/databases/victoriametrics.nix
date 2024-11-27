{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.victoriametrics;
  settingsFormat = pkgs.formats.yaml { };

  startCLIList =
    [
      "${cfg.package}/bin/victoria-metrics"
      "-storageDataPath=/var/lib/${cfg.stateDir}"
      "-httpListenAddr=${cfg.listenAddress}"

    ]
    ++ lib.optionals (cfg.retentionPeriod != null) [ "-retentionPeriod=${cfg.retentionPeriod}" ]
    ++ cfg.extraOptions;
  prometheusConfigYml = checkedConfig (
    settingsFormat.generate "prometheusConfig.yaml" cfg.prometheusConfig
  );

  checkedConfig =
    file:
    pkgs.runCommand "checked-config" { nativeBuildInputs = [ cfg.package ]; } ''
      ln -s ${file} $out
      ${lib.escapeShellArgs startCLIList} -promscrape.config=${file} -dryRun
    '';
in
{
  options.services.victoriametrics = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable VictoriaMetrics in single-node mode.

        VictoriaMetrics is a fast, cost-effective and scalable monitoring solution and time series database.
      '';
    };
    package = mkPackageOption pkgs "victoriametrics" { };

    listenAddress = mkOption {
      default = ":8428";
      type = types.str;
      description = ''
        TCP address to listen for incoming http requests.
      '';
    };

    stateDir = mkOption {
      type = types.str;
      default = "victoriametrics";
      description = ''
        Directory below `/var/lib` to store VictoriaMetrics metrics data.
        This directory will be created automatically using systemd's StateDirectory mechanism.
      '';
    };

    retentionPeriod = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "15d";
      description = ''
        How long to retain samples in storage.
        The minimum retentionPeriod is 24h or 1d. See also -retentionFilter
        The following optional suffixes are supported: s (second), h (hour), d (day), w (week), y (year).
        If suffix isn't set, then the duration is counted in months (default 1)
      '';
    };

    prometheusConfig = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      example = literalExpression ''
        {
          scrape_configs = [
            {
              job_name = "postgres-exporter";
              metrics_path = "/metrics";
              static_configs = [
                {
                  targets = ["1.2.3.4:9187"];
                  labels.type = "database";
                }
              ];
            }
            {
              job_name = "node-exporter";
              metrics_path = "/metrics";
              static_configs = [
                {
                  targets = ["1.2.3.4:9100"];
                  labels.type = "node";
                }
                {
                  targets = ["5.6.7.8:9100"];
                  labels.type = "node";
                }
              ];
            }
          ];
        }
      '';
      description = ''
        Config for prometheus style metrics.
        See the docs: <https://docs.victoriametrics.com/vmagent/#how-to-collect-metrics-in-prometheus-format>
        for more information.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''
        [
          "-httpAuth.username=username"
          "-httpAuth.password=file:///abs/path/to/file"
          "-loggerLevel=WARN"
        ]
      '';
      description = ''
        Extra options to pass to VictoriaMetrics. See the docs:
        <https://docs.victoriametrics.com/single-server-victoriametrics/#list-of-command-line-flags>
        or {command}`victoriametrics -help` for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.victoriametrics = {
      description = "VictoriaMetrics time series database";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      startLimitBurst = 5;

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          startCLIList
          ++ lib.optionals (cfg.prometheusConfig != null) [ "-promscrape.config=${prometheusConfigYml}" ]
        );

        DynamicUser = true;
        RestartSec = 1;
        Restart = "on-failure";
        RuntimeDirectory = "victoriametrics";
        RuntimeDirectoryMode = "0700";
        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";

        # Increase the limit to avoid errors like 'too many open files'  when merging small parts
        LimitNOFILE = 1048576;

        # Hardening
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

      postStart =
        let
          bindAddr =
            (lib.optionalString (lib.hasPrefix ":" cfg.listenAddress) "127.0.0.1") + cfg.listenAddress;
        in
        lib.mkBefore ''
          until ${lib.getBin pkgs.curl}/bin/curl -s -o /dev/null http://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };
  };
}
