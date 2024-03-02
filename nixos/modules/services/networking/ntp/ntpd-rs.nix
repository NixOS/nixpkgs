{ lib, config, pkgs, ... }:

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
      description = lib.mdDoc ''
        Use source time servers from {var}`networking.timeServers` in config.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = lib.mdDoc ''
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
      source = lib.mkIf cfg.useNetworkingTimeServers (map
        (ts: {
          mode = "server";
          address = ts;
        })
        config.networking.timeServers);
    };

    systemd.services.ntpd-rs = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "";
        Group = "";
        DynamicUser = true;
        ExecStart = [ "" "${lib.makeBinPath [ cfg.package ]}/ntp-daemon --config=${configFile}" ];
      };
    };

    systemd.services.ntpd-rs-metrics = lib.mkIf cfg.metrics.enable {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "";
        Group = "";
        DynamicUser = true;
        ExecStart = [ "" "${lib.makeBinPath [ cfg.package ]}/ntp-metrics-exporter --config=${configFile}" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ fpletz ];
}
