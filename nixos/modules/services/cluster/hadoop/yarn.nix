{ config, lib, pkgs, ...}:
let
  cfg = config.services.hadoop;
  hadoopConf = import ./conf.nix { hadoop = cfg; pkgs = pkgs; };
in
with lib;
{
  options.services.hadoop.yarn = {
    resourcemanager.enabled = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run the Hadoop YARN ResourceManager
      '';
    };
    nodemanager.enabled = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to run the Hadoop YARN NodeManager
      '';
    };
  };

  config = mkMerge [
    (mkIf (
        cfg.yarn.resourcemanager.enabled || cfg.yarn.nodemanager.enabled
    ) {

      users.users.yarn = {
        description = "Hadoop YARN user";
        group = "hadoop";
        uid = config.ids.uids.yarn;
      };
    })

    (mkIf cfg.yarn.resourcemanager.enabled {
      systemd.services."yarn-resourcemanager" = {
        description = "Hadoop YARN ResourceManager";
        wantedBy = [ "multi-user.target" ];

        environment = {
          HADOOP_HOME = "${cfg.package}";
        };

        serviceConfig = {
          User = "yarn";
          SyslogIdentifier = "yarn-resourcemanager";
          ExecStart = "${cfg.package}/bin/yarn --config ${hadoopConf} " +
                      " resourcemanager";
        };
      };
    })

    (mkIf cfg.yarn.nodemanager.enabled {
      systemd.services."yarn-nodemanager" = {
        description = "Hadoop YARN NodeManager";
        wantedBy = [ "multi-user.target" ];

        environment = {
          HADOOP_HOME = "${cfg.package}";
        };

        serviceConfig = {
          User = "yarn";
          SyslogIdentifier = "yarn-nodemanager";
          ExecStart = "${cfg.package}/bin/yarn --config ${hadoopConf} " +
                      " nodemanager";
        };
      };
    })

  ];
}
