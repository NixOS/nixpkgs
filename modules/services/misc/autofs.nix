{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.autofs;

in

{

  ###### interface

  options = {
  
    services.autofs = {
    
      enable = mkOption {
        default = false;
        description = "
          automatically mount and unmount filesystems
        ";
      };

      autoMaster = mkOption {
        example = ''
          autoMaster = let
            mapConf = pkgs.writeText "auto" '''
             kernel    -ro,soft,intr       ftp.kernel.org:/pub/linux
             boot      -fstype=ext2        :/dev/hda1
             windoze   -fstype=smbfs       ://windoze/c
             removable -fstype=ext2        :/dev/hdd
             cd        -fstype=iso9660,ro  :/dev/hdc
             floppy    -fstype=auto        :/dev/fd0
             server    -rw,hard,intr       / -ro myserver.me.org:/ \
                                           /usr myserver.me.org:/usr \
                                           /home myserver.me.org:/home
            ''';
          in '''
            /auto file:''${mapConf}
          '''
        '';
        description = "
          file contents of /etc/auto.master. See man auto.master
          see 
          man auto.master and man 5 autofs
        ";
      };

      timeout = mkOption {
        default = 600;
        description = "Set the global minimum timeout, in seconds, until directories are unmounted";
      };

      debug = mkOption {
        default = false;
        description = "pass -d to automount and write log to /var/log/autofs";
      };
      
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = singleton
      { target = "auto.master";
        source = pkgs.writeText "auto.master" cfg.autoMaster;
      };

    jobAttrs.autofs =
      { description = "Filesystem automounter";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        environment =
          { PATH = "${pkgs.nfsUtils}/sbin:${config.system.sbin.modprobe}/sbin";
          };

        preStart =
          ''
            modprobe autofs4 || true
          '';

        script =
          ''
            ${if cfg.debug then "exec &> /var/log/autofs" else ""}
            ${pkgs.autofs5}/sbin/automount -f -t ${builtins.toString cfg.timeout} ${if cfg.debug then "-d" else ""} "${pkgs.writeText "auto.master" cfg.autoMaster}"
          '';
      };
          
  };
  
}
