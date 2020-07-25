{ config, lib, pkgs, ...}:

with lib;
{
  imports = [ ./yarn.nix ./hdfs.nix ];

  options.services.hadoop = {
    coreSite = mkOption {
      default = {};
      example = literalExample ''
        {
          "fs.defaultFS" = "hdfs://localhost";
        }
      '';
      description = "Hadoop core-site.xml definition";
    };

    hdfsSite = mkOption {
      default = {};
      example = literalExample ''
        {
          "dfs.nameservices" = "namenode1";
        }
      '';
      description = "Hadoop hdfs-site.xml definition";
    };

    mapredSite = mkOption {
      default = {};
      example = literalExample ''
        {
          "mapreduce.map.cpu.vcores" = "1";
        }
      '';
      description = "Hadoop mapred-site.xml definition";
    };

    yarnSite = mkOption {
      default = {};
      example = literalExample ''
        {
          "yarn.resourcemanager.ha.id" = "resourcemanager1";
        }
      '';
      description = "Hadoop yarn-site.xml definition";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hadoop;
      defaultText = "pkgs.hadoop";
      example = literalExample "pkgs.hadoop";
      description = ''
      '';
    };
  };


  config = mkMerge [
    (mkIf (builtins.hasAttr "yarn" config.users.users ||
           builtins.hasAttr "hdfs" config.users.users) {
      users.groups.hadoop = {
        gid = config.ids.gids.hadoop;
      };
    })

  ];
}
