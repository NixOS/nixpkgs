{ config, lib, ... }:

let

  inInitrd = lib.any (fs: fs == "squashfs") config.boot.initrd.supportedFilesystems;

in

{

  boot.initrd.availableKernelModules = lib.mkIf inInitrd [ "squashfs" ];

}
