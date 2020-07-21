{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.services.ipfs-cluster;
  opt = options.services.ipfs-cluster;
in {

  ###### interface

  options = {

    services.ipfs-cluster = {

      enable = mkEnableOption "Pinset orchestration for IPFS - requires ipfs daemon to be useful";

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
  	};
 };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ipfs-cluster ];
    environment.variables.IPFS_CLUSTER_PATH = cfg.dataDir;

    systemd.services.ipfs = {
      path = [ "/run/wrappers" pkgs.ipfs-cluster ];
      environment.IPFS_PATH = cfg.dataDir;

      serviceConfig = {
        ExecStart = ["" "${pkgs.ipfs}/bin/ipfs daemon ${ipfsFlags}"];
        User = cfg.user;
        Group = cfg.group;
			};
	};
