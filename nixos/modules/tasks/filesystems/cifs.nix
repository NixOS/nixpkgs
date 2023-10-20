{ config, lib, pkgs, ... }:

with lib;

let

  enabled = any (fs: fs == "cifs") config.boot.supportedFilesystems;

  inInitrd = any (fs: fs == "cifs") config.boot.initrd.supportedFilesystems;

in

{
  config = {

    system.fsPackages = mkIf enabled [ pkgs.cifs-utils ];

    boot.initrd.availableKernelModules = mkIf inInitrd
      [ "cifs" "nls_utf8" "hmac" "md4" "ecb" "des_generic" "sha256" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable)
      ''
        copy_bin_and_libs ${pkgs.cifs-utils}/sbin/mount.cifs
      '';

    programs.keyutils = mkIf enabled {
      enable = true;
      keyPrograms = [
        {
          op = "create";
          type = "cifs.spnego";
          command = "${pkgs.cifs-utils}/bin/cifs.upcall %k";
        }
        {
          op = "create";
          type = "cifs.idmap";
          command = "${pkgs.cifs-utils}/bin/cifs.idmap %k";
        }
      ];
    };

  };
}
