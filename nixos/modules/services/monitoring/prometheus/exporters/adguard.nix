{ config, lib, pkgs, utils, ... }:

let
  cfg = config.services.adguard-exporter;
in
{
  port = 9899;

  extraOpts = {
    interval = lib.lib.mkOption {
      type = lib.lib.types.str;
      default = "10s";
      description = ''
        Interval of time the exporter will fetch data from Adguard.
      '';
    };

    protocol = lib.mkOption {
      type = lib.types.enum [ "http" "https" ];
      default = "http";
      description = ''
        Protocol to use to query Adguard (i.e. the http scheme, either http or https).
      '';
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        Hostname of where Adguard is installed.
      '';
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = ''
        Username to login to Adguard Home.
      '';
    };

    passwordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        File containing the password for the Adguard user.
      '';
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 3000;
      description = ''
        Port to use to communicate with Adguard API.
      '';
    };

    logLimit = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = ''
        Limit for the return log data.
      '';
    };

    exporterPort = lib.mkOption {
      type = lib.types.int;
      default = 9617;
      description = ''
        Port to be used for the exporter.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra arguments passed to adguard-exporter.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = let
      args = [
        "-interval ${cfg.interval}"
        "-adguard_protocol ${cfg.protocol}"
        "-adguard_hostname ${cfg.hostname}"
        "-adguard_username ${cfg.username}"
        "-adguard_password ${cfg.passwordFile}"
        "-password_from_file=true"
        "-adguard_port ${toString cfg.port}"
        "-log_limit ${toString cfg.logLimit}"
        "-server_port ${toString cfg.exporterPort}"
      ] ++ cfg.extraArgs;
    in {
      ExecStart = ''
        ${pkgs.adguard-exporter}/bin/adguard-exporter ${utils.escapeSystemdExecArgs args}
      '';
      Restart = "always";
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "full";
      DevicePolicy = "closed";
      NoNewPrivileges = true;
      DynamicUser = true;
      WorkingDirectory = "/tmp";
    };
  };
}
