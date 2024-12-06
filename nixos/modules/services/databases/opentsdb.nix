{ config, lib, pkgs, ... }:
let
  cfg = config.services.opentsdb;

  configFile = pkgs.writeText "opentsdb.conf" cfg.config;

in {

  ###### interface

  options = {

    services.opentsdb = {

      enable = lib.mkEnableOption "OpenTSDB";

      package = lib.mkPackageOption pkgs "opentsdb" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "opentsdb";
        description = ''
          User account under which OpenTSDB runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "opentsdb";
        description = ''
          Group account under which OpenTSDB runs.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 4242;
        description = ''
          Which port OpenTSDB listens on.
        '';
      };

      config = lib.mkOption {
        type = lib.types.lines;
        default = ''
          tsd.core.auto_create_metrics = true
          tsd.http.request.enable_chunked  = true
        '';
        description = ''
          The contents of OpenTSDB's configuration file
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.opentsdb.enable {

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
