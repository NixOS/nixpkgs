{ config, pkgs, ... }:

with pkgs.lib;

let

  inInitrd = any (fs: fs == "xfs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "xfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.xfsprogs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "xfs" "crc32c" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        cp -v ${pkgs.xfsprogs}/sbin/fsck.xfs $out/bin
      '';

    # Trick just to set 'sh' after the extraUtils nuke-refs.
    boot.initrd.extraUtilsCommandsTest = mkIf inInitrd
      ''
        sed -i -e 's,^#!.*,#!'$out/bin/sh, $out/bin/fsck.xfs
      '';
  };
}
