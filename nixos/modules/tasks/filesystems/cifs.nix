{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "cifs") config.boot.initrd.supportedFilesystems;

in

{
  config = {

    system.fsPackages = [ pkgs.cifs_utils ];

    boot.initrd.availableKernelModules = mkIf inInitrd
      [ "cifs" "nls_utf8" "hmac" "md4" "ecb" "des_generic" "sha256" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        cp -v ${pkgs.cifs_utils}/sbin/mount.cifs $out/bin
      '';

  };
}
