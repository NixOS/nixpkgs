{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.services.ipfs-cluster;
  opt = options.services.ipfs-cluster;
in {

  ###### interface

  options = {

    services.ipfs-cluster = {

      enable = mkEnableOption
        "Pinset orchestration for IPFS - requires ipfs daemon to be useful";

      user = mkOption {
        type = types.str;
        default = "ipfs";
        description = "User under which the ipfs-cluster daemon runs";
      };

      group = mkOption {
        type = types.str;
        default = "ipfs";
        description = "Group under which the ipfs-cluster daemon runs";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/ipfs";
        description = "The data dir for ipfs-cluster";
      };

      consensus = mkOption {
        type = types.str;
        default = null;
        description = "Consensus protocol - 'raft' or 'crdt'";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ipfs-cluster ];
    environment.variables.IPFS_CLUSTER_PATH = cfg.dataDir;

    systemd.packages = [ pkgs.ipfs-cluster ];

    systemd.services.ipfs-cluster-init = {
      path = [ "/run/wrappers" pkgs.ipfs-cluster ];
      environment.IPFS_PATH = cfg.dataDir;
      wantedBy = [ "default.target" ];

      serviceConfig = if cfg.consensus == null then
        throw "ipfs-cluster requires the option 'consensus' to be set"
      else {
        ExecStart = [
          ""
          "${pkgs.ipfs-cluster}/bin/ipfs-cluster-service init --consensus ${cfg.consensus}"
        ];
        Type = "oneshot";
        RemainAfterExit = true;
        User = cfg.user;
        Group = cfg.group;
      };
    };

    systemd.services.ipfs-cluster = {
      path = [ "/run/wrappers" pkgs.ipfs-cluster ];
      environment.IPFS_PATH = cfg.dataDir;
      wantedBy = [ "default.target" ];

      wants = [ "ipfs-cluster-init.service" ];
      after = [ "ipfs-cluster-init.service" ];

      serviceConfig = {
        ExecStart =
          [ "" "${pkgs.ipfs-cluster}/bin/ipfs-cluster-service daemon" ];
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
