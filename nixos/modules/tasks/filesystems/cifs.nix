{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "cifs") config.boot.initrd.supportedFilesystems;

in

{
  config = {

    system.fsPackages = mkIf (any (fs: fs == "cifs") config.boot.supportedFilesystems) [ pkgs.cifs-utils ];

    boot.initrd.availableKernelModules = mkIf inInitrd
      [ "cifs" "nls_utf8" "hmac" "md4" "ecb" "des_generic" "sha256" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        copy_bin_and_libs ${pkgs.cifs-utils}/sbin/mount.cifs
      '';

  };
}
