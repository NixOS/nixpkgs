{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "vboxsf") config.boot.initrd.supportedFilesystems;

  package = pkgs.runCommand "mount.vboxsf" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    cp ${pkgs.linuxPackages.virtualboxGuestAdditions}/bin/mount.vboxsf $out/bin
  '';
in

{
  config = mkIf (any (fs: fs == "vboxsf") config.boot.supportedFilesystems) {

    system.fsPackages = [ package ];

    boot.initrd.kernelModules = mkIf inInitrd [ "vboxsf" ];

  };
}
