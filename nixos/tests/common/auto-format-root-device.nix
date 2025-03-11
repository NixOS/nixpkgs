# This is a test utility that automatically formats
# `config.virtualisation.rootDevice` in the initrd.
# Note that when you are using
# `boot.initrd.systemd.enable = true`, you can use
# `virtualisation.fileSystems."/".autoFormat = true;`
# instead.

{
  lib,
  config,
  pkgs,
  ...
}:

let
  rootDevice = config.virtualisation.rootDevice;
in
{

  boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
    # We need mke2fs in the initrd.
    copy_bin_and_libs ${pkgs.e2fsprogs}/bin/mke2fs
  '';

  boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
    # If the disk image appears to be empty, run mke2fs to
    # initialise.
    FSTYPE=$(blkid -o value -s TYPE ${rootDevice} || true)
    PARTTYPE=$(blkid -o value -s PTTYPE ${rootDevice} || true)
    if test -z "$FSTYPE" -a -z "$PARTTYPE"; then
        mke2fs -t ext4 ${rootDevice}
    fi
  '';
}
