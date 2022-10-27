{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.rpcbind = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable `rpcbind', an ONC RPC directory service
          notably used by NFS and NIS, and which can be queried
          using the rpcinfo(1) command. `rpcbind` is a replacement for
          `portmap`.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.rpcbind.enable {
    environment.systemPackages = [ pkgs.rpcbind ];

    systemd.packages = [ pkgs.rpcbind ];

    systemd.services.rpcbind = {
      wantedBy = [ "multi-user.target" ];
    };

    users.users.rpc = {
      group = "nogroup";
      uid = config.ids.uids.rpc;
    };
  };

}
