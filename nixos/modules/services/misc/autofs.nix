{ config, lib, pkgs, ... }:

with lib;

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
        type = types.str;
        example = literalExample ''
          let
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

    boot.kernelModules = [ "autofs4" ];

    systemd.services.autofs =
      { description = "Automounts filesystems on demand";
        after = [ "network.target" "ypbind.service" "sssd.service" "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        preStart = ''
          # There should be only one autofs service managed by systemd, so this should be safe.
          rm -f /tmp/autofs-running
        '';

        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/autofs.pid";
          ExecStart = "${pkgs.autofs5}/bin/automount ${optionalString cfg.debug "-d"} -p /run/autofs.pid -t ${builtins.toString cfg.timeout} ${autoMaster}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        };
      };

  };

}
