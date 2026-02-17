{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.cifs or false;
  mount_cifs = "${lib.getBin pkgs.cifs-utils}/sbin/mount.cifs";

in

{
  config = {

    system.fsPackages = mkIf (config.boot.supportedFilesystems.cifs or false) [ pkgs.cifs-utils ];

    boot.initrd.availableKernelModules = mkIf inInitrd [
      "cifs"
      "nls_utf8"
      "hmac"
      "md4"
      "ecb"
      "des_generic"
      "sha256"
    ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${mount_cifs}
    '';

    boot.initrd.systemd.extraBin."mount.cifs" = mkIf inInitrd mount_cifs;

  };
}
