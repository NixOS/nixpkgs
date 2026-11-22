{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  inInitrd = config.boot.initrd.supportedFilesystems.jfs or false;
in
{
  config = mkIf (config.boot.supportedFilesystems.jfs or false) {

    system.fsPackages = [ pkgs.jfsutils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "jfs" ];

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.jfsutils ];
  };
}
