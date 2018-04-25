# This module automatically grows the root partition on virtual machines.
# This allows an instance to be created with a bigger root filesystem
# than provided by the machine image.

{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    virtualisation.growPartition = mkOption {
      type = types.bool;
      default = true;
    };

  };

  config = mkIf config.virtualisation.growPartition {

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.gawk}/bin/gawk
      copy_bin_and_libs ${pkgs.gnused}/bin/sed
      copy_bin_and_libs ${pkgs.utillinux}/sbin/sfdisk
      copy_bin_and_libs ${pkgs.utillinux}/sbin/lsblk
      cp -v ${pkgs.cloud-utils}/bin/.growpart-wrapped $out/bin/growpart
      ln -s sed $out/bin/gnused
    '';

    boot.initrd.postDeviceCommands = ''
      rootDevice="${config.fileSystems."/".device}"
      if [ -e "$rootDevice" ]; then
        rootDevice="$(readlink -f "$rootDevice")"
        parentDevice="$rootDevice"
        while [ "''${parentDevice%[0-9]}" != "''${parentDevice}" ]; do
          parentDevice="''${parentDevice%[0-9]}";
        done
        partNum="''${rootDevice#''${parentDevice}}"
        if [ "''${parentDevice%[0-9]p}" != "''${parentDevice}" ] && [ -b "''${parentDevice%p}" ]; then
          parentDevice="''${parentDevice%p}"
        fi
        TMPDIR=/run sh $(type -P growpart) "$parentDevice" "$partNum"
        udevadm settle
      fi
    '';

  };

}
