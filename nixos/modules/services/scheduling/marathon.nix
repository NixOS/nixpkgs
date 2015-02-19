{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.marathon;

in {

  ###### interface

  options.services.marathon = {
    enable = mkOption {
      description = "Whether to enable the marathon mesos framework.";
      default = false;
      type = types.uniq types.bool;
    };

    httpPort = mkOption {
      description = "Marathon listening port";
      default = 8080;
      type = types.int;
    };

    master = mkOption {
      description = "Marathon mesos master zookeeper address";
      default = "zk://${head cfg.zookeeperHosts}/mesos";
      type = types.str;
    };

    zookeeperHosts = mkOption {
      description = "Marathon mesos zookepper addresses";
      default = [ "localhost:2181" ];
      type = types.listOf types.str;
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.marathon = {
      description = "Marathon Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" "zookeeper.service" "mesos-master.service" "mesos-slave.service" ];

      serviceConfig = {
        ExecStart = "${pkgs.marathon}/bin/marathon --master ${cfg.master} --zk zk://${head cfg.zookeeperHosts}/marathon";
        User = "marathon";
      };
    };

    users.extraUsers.marathon = {
      uid = config.ids.uids.marathon;
      description = "Marathon mesos framework user";
    };
  };
}
