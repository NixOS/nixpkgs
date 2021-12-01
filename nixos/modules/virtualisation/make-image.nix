{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.image;
in
{
  options = {
    virtualisation.image = {
      diskSize = mkOption {
        type = with types; either (enum [ "auto" ]) ints.positive;
        default = "auto";
        example = 8192;
        description = ''
          The disk size of the image in MiB.
        '';
      };
      additionalDiskSpace = mkOption {
        type = types.int;
        default = 512;
        example = 1024;
        description = ''
          Additional disk space in MiB to be added to the image if <literal>virtualisation.qcow.baseImageSize</literal> is set to <literal>auto</literal>.
        '';
      };
      bootPartitionSize = mkOption {
        type = types.int.positive;
        default = 256;
        example = 512;
        description = ''
          The size of the boot partition in MiB, only takes effect if <literal>virtualisation.qcow.partitionTableType</literal> is set to <literal>efi</literal> or <literalhybrid</literal>.
        '';
      };
      partitionTableType = mkOption {
        type = types.enum [ "legacy" "efi" "legacy+gpt" "hybrid" "none" ];
        default = "legacy";
        example = "efi";
        description = ''
          Type of partition table to use for the image, available options are <literal>legacy</literal>, <literal>efi</literal>, <literal>legacy+gpt</literal>, <literal>hybrid</literal> or <literal>none</literal>. For additional information about each option: <link>https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/make-disk-image.nix#L32</link>.
        '';
      };
      name = mkOption {
        type = types.str;
        default = "${cfg.format}-image";
        example = "my-custom-nixos-image";
        description = ''
          The name of the produced disk image.
        '';
      };
      format = mkOption {
        type = types.enum [ "qcow2" "qcow2-compressed" "vdi" "vpc" "raw" ];
        default = "raw";
        example = "qcow2";
        description = ''
          The disk image format to be produced, one of <literal>qcow2</literal>, <literal>qcow2-compressed</literal>, <literal>vdi</literal>, <literal>vpc</literal>, <literal>raw</literal>.
        '';
      };
      copyConfigFile = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Initial NixOS configuration file to be copied to <literal>/etc/nixos/configuration.nix</literal> on the produced disk image.
        '';
      };
      file = mkOption {
        readOnly = true;
        type = types.path;
        description = ''
          The generated image derivation, for use by other modules and expressions.
        '';
      };
    };
  };

  config = {
    virtualisation.image.file = import ../../lib/make-disk-image.nix {
      inherit lib config pkgs;
      name = cfg.name;
      format = cfg.format;
      diskSize = "${toString cfg.diskSize}";
      additionalSpace = "${toString cfg.additionalDiskSpace}M";
      bootSize = "${toString cfg.bootPartitionSize}M";
      partitionTableType = cfg.partitionTableType;
      configFile = cfg.copyConfigFile;
    };
  };
}
