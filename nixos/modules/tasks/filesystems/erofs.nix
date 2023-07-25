{ config, lib, pkgs, ... }:

let

  inInitrd = lib.any (fs: fs == "erofs") config.boot.initrd.supportedFilesystems;
  inSystem = lib.any (fs: fs == "erofs") config.boot.supportedFilesystems;

in

{
  config = lib.mkIf (inInitrd || inSystem) {

    system.fsPackages = [ pkgs.erofs-utils ];

    boot.initrd.availableKernelModules = lib.mkIf inInitrd [ "erofs" ];

    # fsck.erofs is currently experimental and should not be run as a
    # privileged user. Thus, it is not included in the initrd.

  };
}
