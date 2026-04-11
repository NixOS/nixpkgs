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

  validateConfig =
    file:
    pkgs.runCommand "validate-ntpd-rs.toml"
      {
        nativeBuildInputs = [ cfg.package ];
      }
      ''
        ntp-ctl validate -c ${file}
        ln -s "${file}" "$out"
      '';
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
          mode = if lib.strings.hasInfix "pool" ts then "pool" else "server";
          address = ts;
        }) config.networking.timeServers
      );
    };

    systemd.services.ntpd-rs = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "";
        Group = "";
        DynamicUser = true;
        ExecStart = [
          ""
          "${lib.makeBinPath [ cfg.package ]}/ntp-daemon --config=${validateConfig configFile}"
        ];

        CapabilityBoundingSet = [
          "CAP_SYS_TIME"
          "CAP_NET_BIND_SERVICE"
        ];
        AmbientCapabilities = [
          "CAP_SYS_TIME"
          "CAP_NET_BIND_SERVICE"
        ];
        LimitCORE = 0;
        LimitNOFILE = 65535;
        LockPersonality = true;
        MemorySwapMax = 0;
        MemoryZSwapMax = 0;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        Restart = "on-failure";
        RestartSec = "10s";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@resources"
          "@network-io"
          "@clock"
        ];
        NoNewPrivileges = true;
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
          "${lib.makeBinPath [ cfg.package ]}/ntp-metrics-exporter --config=${validateConfig configFile}"
        ];

        CapabilityBoundingSet = [ ];
        LimitCORE = 0;
        LimitNOFILE = 65535;
        LockPersonality = true;
        MemorySwapMax = 0;
        MemoryZSwapMax = 0;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        PrivateDevices = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@network-io"
          "~@privileged"
          "~@resources"
          "~@mount"
        ];
        NoNewPrivileges = true;
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ fpletz ];
}
