# This module automatically grows the root partition.
# This allows an instance to be created with a bigger root filesystem
# than provided by the machine image.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    (mkRenamedOptionModule [ "virtualisation" "growPartition" ] [ "boot" "growPartition" ])
  ];

  options = {
    boot.growPartition = mkEnableOption (lib.mdDoc "grow the root partition on boot");
  };

  config = mkIf config.boot.growPartition {

    assertions = [{
      assertion = !config.boot.initrd.systemd.enable;
      message = "systemd stage 1 does not support 'boot.growPartition' yet.";
    }];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.gawk}/bin/gawk
      copy_bin_and_libs ${pkgs.gnused}/bin/sed
      copy_bin_and_libs ${pkgs.util-linux}/sbin/sfdisk
      copy_bin_and_libs ${pkgs.util-linux}/sbin/lsblk

      substitute "${pkgs.cloud-utils.guest}/bin/.growpart-wrapped" "$out/bin/growpart" \
        --replace "${pkgs.bash}/bin/sh" "/bin/sh" \
        --replace "awk" "gawk" \
        --replace "sed" "gnused"

      ln -s sed $out/bin/gnused
    '';

    boot.initrd.postDeviceCommands = ''
      rootDevice="${config.fileSystems."/".device}"
      if waitDevice "$rootDevice"; then
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
