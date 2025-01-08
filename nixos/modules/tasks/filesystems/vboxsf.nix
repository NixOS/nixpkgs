{
  config,
  lib,
  pkgs,
  ...
}:

let

  inInitrd = config.boot.initrd.supportedFilesystems.vboxsf or false;

  package = pkgs.runCommand "mount.vboxsf" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    cp ${pkgs.linuxPackages.virtualboxGuestAdditions}/bin/mount.vboxsf $out/bin
  '';
in

{
  config = lib.mkIf (config.boot.supportedFilesystems.vboxsf or false) {

    system.fsPackages = [ package ];

    boot.initrd.kernelModules = lib.mkIf inInitrd [ "vboxsf" ];

  };
}
