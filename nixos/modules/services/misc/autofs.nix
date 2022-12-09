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
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Mount filesystems on demand. Unmount them automatically.
          You may also be interested in afuse.
        '';
      };

      autoMaster = mkOption {
        type = types.str;
        example = literalExpression ''
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
        description = lib.mdDoc ''
          Contents of `/etc/auto.master` file. See {command}`auto.master(5)` and {command}`autofs(5)`.
        '';
      };

      timeout = mkOption {
        type = types.int;
        default = 600;
        description = lib.mdDoc "Set the global minimum timeout, in seconds, until directories are unmounted";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Pass -d and -7 to automount and write log to the system journal.
        '';
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
