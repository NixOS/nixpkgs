{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.vboxsf or false;

  package = pkgs.runCommand "mount.vboxsf" { } ''
    mkdir -p $out/bin
    cp ${pkgs.linuxPackages.virtualboxGuestAdditions}/bin/mount.vboxsf $out/bin
  '';
in

{
  config = mkIf (config.boot.supportedFilesystems.vboxsf or false) {

    system.fsPackages = [ package ];

    boot.initrd.kernelModules = mkIf inInitrd [ "vboxsf" ];

  };
}
