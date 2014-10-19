{ config, lib, ... }:

with lib;

{

  ###### interface

  options = {

    boot.cleanTmpDir = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to delete all files in <filename>/tmp</filename> during boot.
      '';
    };

    boot.tmpOnTmpfs = mkOption {
      type = types.bool;
      default = false;
      description = ''
         Whether to mount a tmpfs on <filename>/tmp</filename> during boot.
      '';
    };

    boot.tmpSize = mkOption {
      default = "50%";
      example = "512m";
      type = types.str;
      description = ''
        Size limit for the /dev/shm tmpfs. Look at <command>mount(8)</command>, tmpfs size option,
        for the accepted syntax.
      '';
    };

  };

  ###### implementation

  config = {

    systemd.mounts = mkIf config.boot.tmpOnTmpfs [
      { description = "Temporary Directory";
        unitConfig =
          { Documentation = "http://www.freedesktop.org/wiki/Software/systemd/APIFileSystems";
            DefaultDependencies = "no";
          };
        conflicts = [ "umount.target" ];
        before = [ "local-fs.target" "umount.target" ];
        wantedBy = [ "local-fs.target" ];

        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        options = "mode=1777,strictatime,size=${config.boot.tmpSize}";
      }
    ];

    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

    assertions = [
      { assertion = !(config.boot.tmpOnTmpfs && config.boot.cleanTmpDir);
        message = "Both boot.tmpOnTmpfs and boot.cleanTmpDir enabled.";
      }
    ];

  };

}