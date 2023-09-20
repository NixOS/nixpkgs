{ config, lib, ... }:

with lib;

let
  fileSystems = config.system.build.fileSystems ++ config.swapDevices;
  encDevs = filter (dev: dev.encrypted.enable) fileSystems;
  keyedEncDevs = filter (dev: dev.encrypted.keyFile != null) encDevs;
  keylessEncDevs = filter (dev: dev.encrypted.keyFile == null) encDevs;
  anyEncrypted =
    foldr (j: v: v || j.encrypted.enable) false encDevs;

  encryptedFSOptions = {

    options.encrypted = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "The block device is backed by an encrypted one, adds this device as a initrd luks entry.";
      };

      blkDev = mkOption {
        default = null;
        example = "/dev/sda1";
        type = types.nullOr types.str;
        description = lib.mdDoc "Location of the backing encrypted device.";
      };

      label = mkOption {
        default = null;
        example = "rootfs";
        type = types.nullOr types.str;
        description = lib.mdDoc "Label of the unlocked encrypted device. Set `fileSystems.<name?>.device` to `/dev/mapper/<label>` to mount the unlocked device.";
      };

      keyFile = mkOption {
        default = null;
        example = "/mnt-root/root/.swapkey";
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Path to a keyfile used to unlock the backing encrypted
          device. At the time this keyfile is accessed, the
          `neededForBoot` filesystems (see
          `fileSystems.<name?>.neededForBoot`)
          will have been mounted under `/mnt-root`,
          so the keyfile path should usually start with "/mnt-root/".
        '';
      };
    };
  };
in

{

  options = {
    fileSystems = mkOption {
      type = with lib.types; attrsOf (submodule encryptedFSOptions);
    };
    swapDevices = mkOption {
      type = with lib.types; listOf (submodule encryptedFSOptions);
    };
  };

  config = mkIf anyEncrypted {
    assertions = map (dev: {
      assertion = dev.encrypted.label != null;
      message = ''
        The filesystem for ${dev.mountPoint} has encrypted.enable set to true, but no encrypted.label set
      '';
    }) encDevs;

    boot.initrd = {
      luks = {
        devices =
          builtins.listToAttrs (map (dev: {
            name = dev.encrypted.label;
            value = { device = dev.encrypted.blkDev; };
          }) keylessEncDevs);
        forceLuksSupportInInitrd = true;
      };
      postMountCommands =
        concatMapStrings (dev:
          "cryptsetup luksOpen --key-file ${dev.encrypted.keyFile} ${dev.encrypted.blkDev} ${dev.encrypted.label};\n"
        ) keyedEncDevs;
    };
  };
}
