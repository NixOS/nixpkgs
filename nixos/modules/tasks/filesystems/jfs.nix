{
  config,
  lib,
  pkgs,
  ...
}:

let
  inInitrd = config.boot.initrd.supportedFilesystems.jfs or false;
in
{
  config = lib.mkIf (config.boot.supportedFilesystems.jfs or false) {

    system.fsPackages = [ pkgs.jfsutils ];

    boot.initrd.kernelModules = lib.mkIf inInitrd [ "jfs" ];

    boot.initrd.extraUtilsCommands = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.jfsutils}/sbin/fsck.jfs
    '';

    boot.initrd.systemd.initrdBin = lib.mkIf inInitrd [ pkgs.jfsutils ];
  };
}
