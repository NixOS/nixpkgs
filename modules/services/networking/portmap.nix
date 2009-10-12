{ config, pkgs, ... }:

with pkgs.lib;

let

  uid = config.ids.uids.portmap;
  gid = config.ids.gids.portmap;

  portmap = pkgs.portmap.override { daemonUID = uid; daemonGID = gid; };
  
in

{

  ###### interface

  options = {
  
    services.portmap = {
    
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable `portmap', an ONC RPC directory service
          notably used by NFS and NIS, and which can be queried
          using the rpcinfo(1) command.
        '';
      };

      verbose = mkOption {
        default = false;
        description = ''
          Whether to enable verbose output.
        '';
      };

      chroot = mkOption {
        default = "/var/empty";
        description = ''
          If non-empty, a path to change root to.
        '';
      };

    };

  };
  

  ###### implementation

  config = mkIf config.services.portmap.enable {

    users.extraUsers = singleton
      { name = "portmap";
        inherit uid;
        description = "portmap daemon user";
        home = "/var/empty";
      };

    users.extraGroups = singleton
      { name = "portmap";
        inherit gid;
      };

    jobAttrs.portmap =
      { description = "ONC RPC portmap";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        exec =
          ''
            ${portmap}/sbin/portmap -f \
              ${if config.services.portmap.chroot == ""
                then ""
                else "-t \"${config.services.portmap.chroot}\""} \
              ${if config.services.portmap.verbose then "-v" else ""}
          '';
      };

  };

}
