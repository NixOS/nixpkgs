{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "nilfs2") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "nilfs2") config.boot.supportedFilesystems;
  enableNilfs2 = inInitrd || inSystem;

in
{
  config = mkIf enableNilfs2 {
    system.fsPackages = [ pkgs.nilfs-utils ];
    boot.initrd.kernelModules = mkIf inInitrd [ "nilfs2" ];
  };
}
