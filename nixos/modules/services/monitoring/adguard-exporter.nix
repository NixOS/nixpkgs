{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.adguard-exporter;
in {
  options.services.adguard-exporter = {
    enable = mkEnableOption "adguard-exporter";

    interval = mkOption {
      type = types.str;
      default = "10s";
      description = ''
        Interval of time the exporter will fetch data from Adguard
      '';
    };

    protocol = mkOption {
      type = types.str;
      default = "http";
      description = ''
        Protocol to use to query Adguard (i.e. the http scheme, either http or https)
      '';
    };

    hostname = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Hostname of where Adguard is installed
      '';
    };

    username = mkOption {
      type = types.str;
      default = "";
      description = ''
        Username to login to Adguard Home
      '';
    };

    passwordFile = mkOption {
      type = types.str;
      default = "";
      description = ''
        File containing the password for the Adguard user
      '';
    };

    port = mkOption {
      type = types.int;
      default = 3000;
      description = ''
        Port to use to communicate with Adguard API
      '';
    };

    logLimit = mkOption {
      type = types.int;
      default = 1000;
      description = ''
        Limit for the return log data
      '';
    };

    exporterPort = mkOption {
      type = types.int;
      default = 9617;
      description = ''
        Port to be used for the exporter
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra arguments passed to adguard-exporter
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.adguard-exporter = { };
    users.users.adguard-exporter = {
      description = "adguard-exporter Service User";
      group = "adguard-exporter";
      isSystemUser = true;
    };

    systemd.services.adguard-exporter = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = let
        args = lib.concatStringsSep " " ([
          "-interval ${cfg.interval}"
          "-adguard_protocol ${cfg.protocol}"
          "-adguard_hostname ${cfg.hostname}"
          "-adguard_username ${cfg.username}"
          "-adguard_password ${cfg.passwordFile}"
          "-password_from_file=true"
          "-adguard_port ${toString cfg.port}"
          "-log_limit ${toString cfg.logLimit}"
          "-server_port ${toString cfg.exporterPort}"
        ] ++ cfg.extraArgs);
      in {
        ExecStart = "${pkgs.adguard-exporter}/bin/adguard-exporter ${args}";
        Restart = "always";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";
        DevicePolicy = "closed";
        NoNewPrivileges = true;
        User = "adguard-exporter";
        WorkingDirectory = "/tmp";
      };
    };
  };
}
