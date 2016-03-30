# This module automatically grows the root partition on Amazon EC2 HVM
# instances. This allows an instance to be created with a bigger root
# filesystem than provided by the AMI.

{ config, lib, pkgs, ... }:

{
  config = mkIf config.ec2.hvm {
    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.gawk}/bin/gawk
      copy_bin_and_libs ${pkgs.gnused}/bin/sed
      copy_bin_and_libs ${pkgs.utillinux}/sbin/sfdisk
      cp -v ${pkgs.cloud-utils}/bin/growpart $out/bin/growpart
      ln -s sed $out/bin/gnused
    '';

    boot.initrd.postDeviceCommands = ''
      if [ -e /dev/xvda ] && [ -e /dev/xvda1 ]; then
        TMPDIR=/run sh $(type -P growpart) /dev/xvda 1
        udevadm settle
      fi
    '';
  };
}
