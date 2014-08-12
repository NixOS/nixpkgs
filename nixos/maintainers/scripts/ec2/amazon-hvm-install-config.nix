{ config, pkgs, lib, ...}:
let
  cloudUtils = pkgs.fetchurl {
    url = "https://launchpad.net/cloud-utils/trunk/0.27/+download/cloud-utils-0.27.tar.gz";
    sha256 = "16shlmg36lidp614km41y6qk3xccil02f5n3r4wf6d1zr5n4v8vd";
  };
  growpart = pkgs.stdenv.mkDerivation {
    name = "growpart";
    src = cloudUtils;
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
  imports = [ ./amazon-base-config.nix ];
  ec2.hvm = true;
  boot.loader.grub.device = lib.mkOverride 0 "nodev";

  boot.initrd.extraUtilsCommands = ''
    cp -v ${pkgs.gawk}/bin/gawk $out/bin/gawk
    cp -v ${pkgs.gnused}/bin/sed $out/bin/gnused
    cp -v ${pkgs.utillinux}/sbin/sfdisk $out/bin/sfdisk
    cp -v ${growpart} $out/bin/growpart
  '';
  boot.initrd.postDeviceCommands = ''
    [ -e /dev/xvda ] && [ -e /dev/xvda1 ] && TMPDIR=/run sh $(type -P growpart) /dev/xvda 1
  '';
}
