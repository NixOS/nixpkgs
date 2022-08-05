{ config, lib, ... }:

with lib;

let
  cfg = config.boot;
  
  tmpOnTmpfsOptions = {
    enable = mkEnableOption "mounting a tmpfs on {file}`/tmp` during boot.";
    size = mkOption {
      type = types.either types.str types.types.ints.positive;
      default = "50%";
      description = lib.mdDoc ''
        Size of tmpfs in percentage.
        Percentage is defined by systemd.
      '';
    };
  };
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
      type = types.either types.bool ( types.submodule { options = tmpOnTmpfsOptions; } );
      default = {
        enable = false;
        size = "50%";
      };
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

  config = let
    legacy = builtins.isBool cfg.tmpOnTmpfs;
    tmpOnTmpfs = if legacy then cfg.tmpOnTmpfs else cfg.tmpOnTmpfs.enable;
    tmpOnTmpfsSize = if legacy then cfg.tmpOnTmpfsSize else cfg.tmpOnTmpfs.size;
  in {
    warnings = 
      optional legacy "Deprecated: boot = { tmpOnTmpfs = …; tmpOnTmpfsSize = …; } should be replaced by boot.tmpOnTmpfs = { enable = …; size = …; }.";

    # When changing remember to update /tmp mount in virtualisation/qemu-vm.nix
    systemd.mounts = mkIf tmpOnTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        type = "tmpfs";
        mountConfig.Options = concatStringsSep "," [ "mode=1777"
                                                     "strictatime"
                                                     "rw"
                                                     "nosuid"
                                                     "nodev"
                                                     "size=${toString tmpOnTmpfsSize}" ];
      }
    ];

    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

  };

}
