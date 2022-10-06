{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "nilfs2") config.boot.initrd.supportedFilesystems;

  # this file is mandatory for nilfs_cleanerd - can be empty
  cleaner_conf = pkgs.writeText "nilfs_cleanerd.conf" ''
    ${concatStringsSep "\n" (attrValues (flip mapAttrs config.boot.nilfs2.cleanerd_conf (name: def:
      optionalString (def != "")
        ''
          ${name} = ${def}
        '')))}
  '';

in

{
  config = mkIf (any (fs: fs == "nilfs2") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.nilfs-utils ];

    boot.initrd.availableKernelModules = mkIf inInitrd [ "nilfs2" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable)
      ''
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/chcp
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/lscp
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/mkcp
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/mount.nilfs2
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/nilfs-clean
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/nilfs-resize
        copy_bin_and_libs ${pkgs.nilfs-utils}/bin/rmcp
      '';

    environment.etc = {
      "nilfs_cleanerd.conf".source = cleaner_conf;
    };

  };

  options = {
    boot.nilfs2 = {
      cleanerd_conf = mkOption {
        type = types.attrsOf types.lines;
        default = {};
        example = ''
        {
          protection_period = "3600";
          cleaning_interval = "120";
        }
        '';
        description = lib.mdDoc ''
          Content of nilfs_cleanerd.conf used to manage garbage collector behavior.

          More information in nilfs_cleanerd.conf man page.
        '';
      };
    };
  };
}
