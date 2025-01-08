{
  config,
  lib,
  pkgs,
  ...
}:

let

  inInitrd = config.boot.initrd.supportedFilesystems.cifs or false;

in

{
  config = {

    system.fsPackages = lib.mkIf (config.boot.supportedFilesystems.cifs or false) [ pkgs.cifs-utils ];

    boot.initrd.availableKernelModules = lib.mkIf inInitrd [
      "cifs"
      "nls_utf8"
      "hmac"
      "md4"
      "ecb"
      "des_generic"
      "sha256"
    ];

    boot.initrd.extraUtilsCommands = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.cifs-utils}/sbin/mount.cifs
    '';

    boot.initrd.systemd.extraBin."mount.cifs" = lib.mkIf inInitrd "${pkgs.cifs-utils}/sbin/mount.cifs";

  };
}
