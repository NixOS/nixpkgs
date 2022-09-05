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
      description = lib.mdDoc ''
        Whether to delete all files in {file}`/tmp` during boot.
      '';
    };

    boot.tmpOnTmpfs = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
         Whether to mount a tmpfs on {file}`/tmp` during boot.
      '';
    };

    boot.tmpOnTmpfsSize = mkOption {
      type = types.oneOf [ types.str types.types.ints.positive ];
      default = "50%";
      description = lib.mdDoc ''
        Size of tmpfs in percentage.
        Percentage is defined by systemd.
      '';
    };

  };

  ###### implementation

  config = {

    # When changing remember to update /tmp mount in virtualisation/qemu-vm.nix
    systemd.mounts = mkIf cfg.tmpOnTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        mountConfig.Options = concatStringsSep "," [ "mode=1777"
                                                     "strictatime"
                                                     "rw"
                                                     "nosuid"
                                                     "nodev"
                                                     "size=${toString cfg.tmpOnTmpfsSize}" ];
      }
    ];

    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

  };

}
