{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hbase;

in {

  ###### interface

  options = {

    services.hbase = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run HBase.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.hbase;
        example = literalExample "pkgs.hbase";
        description = ''
          HBase package to use.
        '';
      };


      user = mkOption {
        type = types.string;
        default = "hbase";
        description = ''
          User account under which HBase runs.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "hbase";
        description = ''
          Group account under which HBase runs.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/hbase";
        description = ''
          Specifies location of HBase database files. This location should be
          writable and readable for the user the HBase service runs as
          (hbase by default).
        '';
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/hbase";
        description = ''
          Specifies the location of HBase log files.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.hbase.enable {

    systemd.services.hbase = {
      description = "HBase Server";
      wantedBy = [ "multi-user.target" ];

      environment = {
        JAVA_HOME = "${pkgs.jre}";
        HBASE_LOG_DIR = cfg.logDir;
      };

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/hbase master start";
      };
    };

    users.extraUsers.hbase = {
      description = "HBase Server user";
      group = "hbase";
      uid = config.ids.uids.hbase;
    };

    users.extraGroups.hbase.gid = config.ids.gids.hbase;

  };
}
