{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.ntpd-rs;
  format = pkgs.formats.toml { };
  configFile = format.generate "ntpd-rs.toml" cfg.settings;
in
{
  options.services.ntpd-rs = {
    enable = lib.mkEnableOption "Network Time Service (ntpd-rs)";
    metrics.enable = lib.mkEnableOption "ntpd-rs Prometheus Metrics Exporter";

    package = lib.mkPackageOption pkgs "ntpd-rs" { };

    useNetworkingTimeServers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use source time servers from {var}`networking.timeServers` in config.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = ''
        Settings to write to {file}`ntp.toml`

        See <https://docs.ntpd-rs.pendulum-project.org/man/ntp.toml.5>
        for more information about available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.timesyncd.enable;
        message = ''
          `ntpd-rs` is not compatible with `services.timesyncd`. Please disable one of them.
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    services.timesyncd.enable = false;
    systemd.services.systemd-timedated.environment = {
      SYSTEMD_TIMEDATED_NTP_SERVICES = "ntpd-rs.service";
    };

    services.ntpd-rs.settings = {
      observability = {
        observation-path = lib.mkDefault "/var/run/ntpd-rs/observe";
      };
      source = lib.mkIf cfg.useNetworkingTimeServers (
        map (ts: {
          mode = "server";
          address = ts;
        }) config.networking.timeServers
      );
    };

    systemd.services.ntpd-rs = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "";
        Group = "";
        ExecStart = [
          ""
          "${lib.makeBinPath [ cfg.package ]}/ntp-daemon --config=${configFile}"
        ];

        # required to run, without these ntpd-rs reports an error
        # "Insufficient permissions to interact with the clock"
        PrivateUsers = false;
        ProtectClock = false;

        # hardening
        DynamicUser = true;
        CapabilityBoundingSet = [
          "CAP_NET_BIND_SERVICE" # required to bind port 123
          "CAP_SYS_TIME" # required to set system clock
        ];
        AmbientCapabilities = [ "CAP_SYS_TIME" ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        PrivateDevices = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "@clock"
        ];
        SystemCallErrorNumber = "EPERM";
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        UMask = "0077";
      };
    };

    systemd.services.ntpd-rs-metrics = lib.mkIf cfg.metrics.enable {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "";
        Group = "";
        DynamicUser = true;
        ExecStart = [
          ""
          "${lib.makeBinPath [ cfg.package ]}/ntp-metrics-exporter --config=${configFile}"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ fpletz ];
}
