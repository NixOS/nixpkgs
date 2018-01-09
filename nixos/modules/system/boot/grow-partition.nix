# This module automatically grows the root partition.
# This allows an instance to be created with a bigger root filesystem
# than provided by the machine image.

{ config, lib, pkgs, ... }:

with lib;

{

  options = {
    boot.growPartition = mkEnableOption "grow the root partition on boot";
  };

  config = mkIf config.boot.growPartition {

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.gawk}/bin/gawk
      copy_bin_and_libs ${pkgs.gnused}/bin/sed
      copy_bin_and_libs ${pkgs.utillinux}/sbin/sfdisk
      copy_bin_and_libs ${pkgs.utillinux}/sbin/lsblk

      substitute "${pkgs.cloud-utils}/bin/.growpart-wrapped" "$out/bin/growpart" \
        --replace "${pkgs.bash}/bin/sh" "/bin/sh" \
        --replace "awk" "gawk" \
        --replace "sed" "gnused"

      ln -s sed $out/bin/gnused
    '';

    boot.initrd.postDeviceCommands = ''
      rootDevice="${config.fileSystems."/".device}"
      if [ -e "$rootDevice" ]; then
        rootDevice="$(readlink -f "$rootDevice")"
        parentDevice="$(lsblk -npo PKNAME "$rootDevice")"
        TMPDIR=/run sh $(type -P growpart) "$parentDevice" "''${rootDevice#$parentDevice}"
        udevadm settle
      fi
    '';

  };

}
