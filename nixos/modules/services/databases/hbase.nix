{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hbase;

  configFile = pkgs.writeText "hbase-site.xml" ''
    <configuration>
      <property>
        <name>hbase.rootdir</name>
        <value>file://${cfg.dataDir}/hbase</value>
      </property>
      <property>
        <name>hbase.zookeeper.property.dataDir</name>
        <value>${cfg.dataDir}/zookeeper</value>
      </property>
    </configuration>
  '';

  configDir = pkgs.runCommand "hbase-config-dir" { preferLocalBuild = true; } ''
    mkdir -p $out
    cp ${cfg.package}/conf/* $out/
    rm $out/hbase-site.xml
    ln -s ${configFile} $out/hbase-site.xml
  '' ;

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
        defaultText = literalExpression "pkgs.hbase";
        description = ''
          HBase package to use.
        '';
      };


      user = mkOption {
        type = types.str;
        default = "hbase";
        description = ''
          User account under which HBase runs.
        '';
      };

      group = mkOption {
        type = types.str;
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

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
      "d '${cfg.logDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.hbase = {
      description = "HBase Server";
      wantedBy = [ "multi-user.target" ];

      environment = {
        JAVA_HOME = "${pkgs.jre}";
        HBASE_LOG_DIR = cfg.logDir;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/hbase --config ${configDir} master start";
      };
    };

    users.users.hbase = {
      description = "HBase Server user";
      group = "hbase";
      uid = config.ids.uids.hbase;
    };

    users.groups.hbase.gid = config.ids.gids.hbase;

  };
}
