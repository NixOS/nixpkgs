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

  };

  ###### implementation

  config = {

    systemd.additionalUpstreamSystemUnits = optional config.boot.tmpOnTmpfs "tmp.mount";

    # we override the mount options, because systemd defaults to a size of 10% and an inode limit of 400k since 246
    # the 10% size was reverted in 247, but the inode limit kept
    # for large (e.g. chromium or libreoffice) or many concurrent builds in /tmp, running into this is quite easy
    # the override works with regular systemd unit merging logic
    systemd.mounts = mkIf config.boot.tmpOnTmpfs [
      {
        what = "tmpfs";
        where = "/tmp";
        mountConfig.Options = [ "mode=1777" "strictatime" "rw" "nosuid" "nodev" "size=50%" ];
      }
    ];

    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

  };

}
