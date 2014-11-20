{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opentsdb;

  configFile = pkgs.writeText "opentsdb.conf" ''
    tsd.core.auto_create_metrics = true
  '';

in {

  ###### interface

  options = {

    services.opentsdb = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run OpenTSDB.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.opentsdb;
        example = literalExample "pkgs.opentsdb";
        description = ''
          OpenTSDB package to use.
        '';
      };

      user = mkOption {
        type = types.string;
        default = "opentsdb";
        description = ''
          User account under which OpenTSDB runs.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "opentsdb";
        description = ''
          Group account under which OpenTSDB runs.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 4242;
        description = ''
          Which port OpenTSDB listens on.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.opentsdb.enable {

    systemd.services.opentsdb = {
      description = "OpenTSDB Server";
      wantedBy = [ "multi-user.target" ];
      requires = [ "hbase.service" ];

      environment.JAVA_HOME = "${pkgs.jre}";
      path = [ pkgs.gnuplot ];

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/tsdb tsd --staticroot=${cfg.package}/share/opentsdb/static --cachedir=/tmp/opentsdb --port=${toString cfg.port} --config=${configFile}";
      };
    };

    users.extraUsers.opentsdb = {
      description = "OpenTSDB Server user";
      group = "opentsdb";
      uid = config.ids.uids.opentsdb;
    };

    users.extraGroups.opentsdb.gid = config.ids.gids.opentsdb;

  };
}
