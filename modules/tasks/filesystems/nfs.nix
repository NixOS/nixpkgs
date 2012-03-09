{ config, pkgs, ... }:

with pkgs.lib;

let

  inInitrd = any (fs: fs == "nfs") config.boot.initrd.supportedFilesystems;

in

{
  config = {

    system.fsPackages = [ pkgs.nfsUtils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "nfs" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        # !!! Uh, why don't we just install mount.nfs?
        cp -v ${pkgs.klibc}/lib/klibc/bin.static/nfsmount $out/bin
      '';

  };
}
