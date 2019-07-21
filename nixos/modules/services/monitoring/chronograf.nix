{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chronograf;
in
{

  options.services.chronograf = {
    enable = mkEnableOption "chronograf server";

    port = mkOption {
      default = 8888;
      type = types.int;
      description = ''
        The port where chronograf is going to be listening.
      '';
    };

    dataDir = mkOption {
      default = "/var/db/chronograf";
      type = types.str;
      description = ''
        Data directory for chronograf data files.
      '';
    };

    influxdbURL = mkOption {
      default = "";
      type = types.str;
      description = ''
        The URL of the InfluxDB that Chronograf is going to connect to.
      '';
      example ="http://localhost:8086";
    };

    kapacitorURL = mkOption {
      default = "";
      type = types.str;
      description = ''
        The URL of the Kapacitor that Chronograf is going to connect to.
      '';
    };

    reporting = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Disable reporting of usage stats (os,arch,version,cluster_id,uptime) once every 24hr.
      '';
    };

    extraConfig = mkOption {
      default = {};
      type = types.attrsOf types.str;
      description = ''
        Chronograf can be configured using environment variables. For more information,
        check https://docs.influxdata.com/chronograf/v1.7/administration/config-options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 chronograf chronograf - -"
    ];

    systemd.services.chronograf = {
      description = "Chronograf server";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${if cfg.extraConfig != {} then "${toString (mapAttrsToList (name: value: "${name}=\"${value}\"") cfg.extraConfig)}" else ""} ${pkgs.chronograf}/bin/chronograf \
          --port=${toString cfg.port} \
          --bolt-path=${cfg.dataDir}/chronograf-v1.db ${if cfg.influxdbURL != "" then ''\
          --influxdb-url=${cfg.influxdbURL}'' else ""} ${if cfg.kapacitorURL != "" then ''\
          --kapacitor-url=${cfg.kapacitorURL}'' else ""} ${if !cfg.reporting then ''\
          --reporting-disabled'' else ""}
      '';
      serviceConfig = {
        ExecReload="${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "chronograf";
        Group = "chronograf";
        Restart = "on-failure";
      };
    };

    users.users.chronograf = {
      description = "chronograf daemon user";
      group = "chronograf";
    };

    users.groups.chronograf = {};
  };

}
