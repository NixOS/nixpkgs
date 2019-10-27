{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chronos;

in {

  ###### interface

  options.services.chronos = {
    enable = mkOption {
      description = "Whether to enable graphite web frontend.";
      default = false;
      type = types.bool;
    };

    httpPort = mkOption {
      description = "Chronos listening port";
      default = 4400;
      type = types.int;
    };

    master = mkOption {
      description = "Chronos mesos master zookeeper address";
      default = "zk://${head cfg.zookeeperHosts}/mesos";
      type = types.str;
    };

    zookeeperHosts = mkOption {
      description = "Chronos mesos zookepper addresses";
      default = [ "localhost:2181" ];
      type = types.listOf types.str;
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.chronos = {
      description = "Chronos Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "zookeeper.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.chronos}/bin/chronos --master ${cfg.master} --zk_hosts ${concatStringsSep "," cfg.zookeeperHosts} --http_port ${toString cfg.httpPort}";
        User = "chronos";
      };
    };

    users.users.chronos.uid = config.ids.uids.chronos;
  };
}
