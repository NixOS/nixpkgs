{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.autofs;

  autoMaster = pkgs.writeText "auto.master" cfg.autoMaster;

in

{

  ###### interface

  options = {

    services.autofs = {

      enable = mkOption {
        default = false;
        description = "
          Mount filesystems on demand. Unmount them automatically.
          You may also be interested in afuese.
        ";
      };

      autoMaster = mkOption {
        example = literalExample ''
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
          See man 5 auto.master and man 5 autofs.
        ";
      };

      timeout = mkOption {
        default = 600;
        description = "Set the global minimum timeout, in seconds, until directories are unmounted";
      };

      debug = mkOption {
        default = false;
        description = "
        pass -d and -7 to automount and write log to /var/log/autofs
        ";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = singleton
      { target = "auto.master";
        source = pkgs.writeText "auto.master" cfg.autoMaster;
      };

    boot.kernelModules = [ "autofs4" ];

    jobs.autofs =
      { description = "Filesystem automounter";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        path = [ pkgs.nfsUtils pkgs.sshfsFuse ];

        preStop =
          ''
            set -e; while :; do pkill -TERM automount; sleep 1; done
          '';

        # automount doesn't clean up when receiving SIGKILL.
        # umount -l should unmount the directories recursively when they are no longer used
        # It does, but traces are left in /etc/mtab. So unmount recursively..
        postStop =
          ''
          PATH=${pkgs.gnused}/bin:${pkgs.coreutils}/bin
          exec &> /tmp/logss
          # double quote for sed:
          escapeSpaces(){ sed 's/ /\\\\040/g'; }
          unescapeSpaces(){ sed 's/\\040/ /g'; }
          sed -n 's@^\s*\(\([^\\ ]\|\\ \)*\)\s.*@\1@p' ${autoMaster} | sed 's/[\\]//' | while read mountPoint; do
            sed -n "s@[^ ]\+\s\+\($(echo "$mountPoint"| escapeSpaces)[^ ]*\).*@\1@p" /proc/mounts | sort -r | unescapeSpaces| while read smountP; do
              ${pkgs.utillinux}/bin/umount -l "$smountP" || true
            done
          done
          '';

        script =
          ''
            ${if cfg.debug then "exec &> /var/log/autofs" else ""}
            exec ${pkgs.autofs5}/sbin/automount ${if cfg.debug then "-d" else ""} -f -t ${builtins.toString cfg.timeout} "${autoMaster}" ${if cfg.debug then "-l7" else ""}
          '';
      };

  };

}
