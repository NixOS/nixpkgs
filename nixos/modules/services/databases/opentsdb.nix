{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.opentsdb;

  configFile = pkgs.writeText "opentsdb.conf" cfg.config;

in {

  ###### interface

  options = {

    services.opentsdb = {

      enable = mkEnableOption (lib.mdDoc "OpenTSDB");

      package = mkOption {
        type = types.package;
        default = pkgs.opentsdb;
        defaultText = literalExpression "pkgs.opentsdb";
        description = lib.mdDoc ''
          OpenTSDB package to use.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "opentsdb";
        description = lib.mdDoc ''
          User account under which OpenTSDB runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "opentsdb";
        description = lib.mdDoc ''
          Group account under which OpenTSDB runs.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 4242;
        description = lib.mdDoc ''
          Which port OpenTSDB listens on.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = ''
          tsd.core.auto_create_metrics = true
          tsd.http.request.enable_chunked  = true
        '';
        description = lib.mdDoc ''
          The contents of OpenTSDB's configuration file
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

      preStart =
        ''
        COMPRESSION=NONE HBASE_HOME=${config.services.hbase.package} ${cfg.package}/share/opentsdb/tools/create_table.sh
        '';

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/tsdb tsd --staticroot=${cfg.package}/share/opentsdb/static --cachedir=/tmp/opentsdb --port=${toString cfg.port} --config=${configFile}";
      };
    };

    users.users.opentsdb = {
      description = "OpenTSDB Server user";
      group = "opentsdb";
      uid = config.ids.uids.opentsdb;
    };

    users.groups.opentsdb.gid = config.ids.gids.opentsdb;

  };
}
