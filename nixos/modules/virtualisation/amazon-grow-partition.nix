# This module automatically grows the root partition on Amazon EC2 HVM
# instances. This allows an instance to be created with a bigger root
# filesystem than provided by the AMI.

{ config, lib, pkgs, ... }:

with lib;

let

  growpart = pkgs.stdenv.mkDerivation {
    name = "growpart";
    src = pkgs.fetchurl {
      url = "https://launchpad.net/cloud-utils/trunk/0.27/+download/cloud-utils-0.27.tar.gz";
      sha256 = "16shlmg36lidp614km41y6qk3xccil02f5n3r4wf6d1zr5n4v8vd";
    };
    patches = [ ./growpart-util-linux-2.26.patch ];
    buildPhase = ''
      cp bin/growpart $out
      sed -i 's|awk|gawk|' $out
      sed -i 's|sed|gnused|' $out
    '';
    dontInstall = true;
    dontPatchShebangs = true;
  };

in

{

  config = mkIf config.ec2.hvm {

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.gawk}/bin/gawk
      copy_bin_and_libs ${pkgs.gnused}/bin/sed
      copy_bin_and_libs ${pkgs.utillinux}/sbin/sfdisk
      cp -v ${growpart} $out/bin/growpart
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
