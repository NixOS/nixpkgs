{ config, lib, ... }:

let

  inInitrd = config.boot.initrd.supportedFilesystems.squashfs or false;

in

{

  boot.initrd.availableKernelModules = lib.mkIf inInitrd [ "squashfs" ];

}
