{pkgs, config, ...}:

with pkgs.lib;

let
  luksRoot = config.boot.initrd.luksRoot;
in
{

  options = {

    boot.initrd.luksRoot = mkOption {
      default = "";
      example = "/dev/sda3";
      description = '';
        The device that should be decrypted using LUKS before trying to mount the
        root partition. This works for both LVM-over-LUKS and LUKS-over-LVM setups.
         
        Make sure that initrd has the crypto modules needed for decryption.

        The decrypted device name is /dev/mapper/luksroot.
      '';
    };

  };



  config = mkIf (luksRoot != "") {

    boot.initrd.extraUtilsCommands = ''
      cp -r ${pkgs.cryptsetup}/lib/* $out/lib/
      cp -r ${pkgs.popt}/lib/* $out/lib
      cp ${pkgs.cryptsetup}/sbin/* $out/bin
    '';

    boot.initrd.postDeviceCommands = ''
      cryptsetup luksOpen ${luksRoot} luksroot
      lvm vgscan
      lvm vgchange -ay
    '';

  };

}