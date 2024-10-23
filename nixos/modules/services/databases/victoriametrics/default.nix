{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.victoriametrics;
  yaml = pkgs.formats.yaml { };

  promTypes = import ./promTypes.nix { inherit lib; };

  bindAddr = "${cfg.listenAddress}:${builtins.toString cfg.port}";
  workingDir = "/var/lib/" + cfg.stateDir;

  generatedPrometheusYml = yaml.generate "prometheus.yml" scrapeConfig;

  # This becomes the main config file for VictoriaMetrics's `-promscrape.config`
  # https://docs.victoriametrics.com/vmagent/#how-to-collect-metrics-in-prometheus-format
  scrapeConfig = {
    global = filterValidPrometheus cfg.globalConfig;
    scrape_configs = filterValidPrometheus cfg.scrapeConfigs;
  };

  filterValidPrometheus = filterAttrsListRecursive (n: v: !(n == "_module" || v == null));
  filterAttrsListRecursive =
    pred: x:
    if isAttrs x then
      listToAttrs (
        concatMap (
          name:
          let
            v = x.${name};
          in
          if pred name v then [ (nameValuePair name (filterAttrsListRecursive pred v)) ] else [ ]
        ) (attrNames x)
      )
    else if isList x then
      map (filterAttrsListRecursive pred) x
    else
      x;
in
{
  options.services.victoriametrics = {
    enable = mkEnableOption "VictoriaMetrics, a time series database, long-term remote storage for victoriametrics";
    package = mkPackageOption pkgs "victoriametrics" { };

    port = mkOption {
      type = types.port;
      default = 8428;
      description = ''
        Port to listen on.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        The listen address for the http interface.
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

    globalConfig = mkOption {
      type = promTypes.globalConfig;
      default = { };
      description = ''
        Parameters that are valid in all  configuration contexts. They
        also serve as defaults for other configuration sections
      '';
    };

    scrapeConfigs = mkOption {
      type = types.listOf promTypes.scrape_config;
      default = [ ];
      description = ''
        A list of scrape configurations.
        See docs: <https://docs.victoriametrics.com/vmagent/#how-to-collect-metrics-in-prometheus-format>
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra options to pass to VictoriaMetrics. See the README:
        <https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/README.md>
        or {command}`victoriametrics -help` for more
        information.
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
        ExecStart = ''
          ${cfg.package}/bin/victoria-metrics \
              -storageDataPath=${workingDir} \
              -httpListenAddr=${bindAddr} \
              -retentionPeriod=${cfg.retentionTime} \
              -promscrape.config=${generatedPrometheusYml} \
              ${lib.escapeShellArgs cfg.extraFlags}
        '';
        DynamicUser = true;
        RestartSec = 1;
        Restart = "on-failure";
        RuntimeDirectory = "victoriametrics";
        RuntimeDirectoryMode = "0700";
        WorkingDirectory = workingDir;
        StateDirectory = cfg.stateDir;
        StateDirectoryMode = "0700";

        # Increase the limit to avoid errors like 'too many open files'  when merging small parts
        LimitNOFILE = 1048576;

        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
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

      postStart = lib.mkBefore ''
        until ${lib.getBin pkgs.curl}/bin/curl -s -o /dev/null http://${bindAddr}/ping; do
          sleep 1;
        done
      '';
    };
  };
}
