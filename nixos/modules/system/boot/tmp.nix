{ config, lib, ... }:

with lib;

let
  cfg = config.boot;
in
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

    boot.tmpOnTmpfsSize = mkOption {
      type = types.str;
      default = "50%";
      description = ''
        Size of tmpfs in percentage.
      '';
    };

  };

  ###### implementation

  config = {

    systemd.mounts = mkIf config.boot.tmpOnTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        mountConfig.Options = [ "mode=1777" "strictatime" "rw" "nosuid" "nodev" "size=${cfg.tmpOnTmpfsSize}" ];
      }
    ];

    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

  };

}
