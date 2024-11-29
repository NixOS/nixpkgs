{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nezha-agent;
in
{
  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };
  options = {
    services.nezha-agent = {
      enable = lib.mkEnableOption "Agent of Nezha Monitoring";

      package = lib.mkPackageOption pkgs "nezha-agent" { };
      debug = lib.mkEnableOption "verbose log";
      tls = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable SSL/TLS encryption.
        '';
      };
      gpu = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable GPU monitoring.
        '';
      };
      temperature = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable temperature monitoring.
        '';
      };
      useIPv6CountryCode = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Use ipv6 countrycode to report location.
        '';
      };
      disableCommandExecute = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Disable executing the command from dashboard.
        '';
      };
      disableNat = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Disable NAT penetration.
        '';
      };
      disableSendQuery = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Disable sending TCP/ICMP/HTTP requests.
        '';
      };
      skipConnection = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not monitor the number of connections.
        '';
      };
      skipProcess = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not monitor the number of processes.
        '';
      };
      reportDelay = lib.mkOption {
        type = lib.types.enum [
          1
          2
          3
          4
        ];
        default = 1;
        description = ''
          The interval between system status reportings.
          The value must be an integer from 1 to 4
        '';
      };
      passwordFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to the file contained the password from dashboard.
        '';
      };
      server = lib.mkOption {
        type = lib.types.str;
        description = ''
          Address to the dashboard
        '';
      };
      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--gpu" ];
        description = ''
          Extra command-line flags passed to nezha-agent.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    systemd.services.nezha-agent = {
      serviceConfig = {
        ProtectSystem = "full";
        PrivateDevices = "yes";
        PrivateTmp = "yes";
        NoNewPrivileges = true;
      };
      path = [ cfg.package ];
      startLimitIntervalSec = 10;
      startLimitBurst = 3;
      script = lib.concatStringsSep " " (
        [
          "${lib.getExe cfg.package}"
          "--disable-auto-update"
          "--disable-force-update"
          "--password $(cat ${cfg.passwordFile})"
        ]
        ++ lib.optional cfg.debug "--debug"
        ++ lib.optional cfg.disableCommandExecute "--disable-command-execute"
        ++ lib.optional cfg.disableNat "--disable-nat"
        ++ lib.optional cfg.disableSendQuery "--disable-send-query"
        ++ lib.optional (cfg.reportDelay != null) "--report-delay ${toString cfg.reportDelay}"
        ++ lib.optional (cfg.server != null) "--server ${cfg.server}"
        ++ lib.optional cfg.skipConnection "--skip-conn"
        ++ lib.optional cfg.skipProcess "--skip-procs"
        ++ lib.optional cfg.tls "--tls"
        ++ lib.optional cfg.gpu "--gpu"
        ++ lib.optional cfg.temperature "--temperature"
        ++ lib.optional cfg.useIPv6CountryCode "--use-ipv6-countrycode"
        ++ cfg.extraFlags
      );
      wantedBy = [ "multi-user.target" ];
    };
  };
}
