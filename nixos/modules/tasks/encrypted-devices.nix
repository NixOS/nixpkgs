{ config, lib, ... }:

with lib;

let
  fileSystems = config.system.build.fileSystems ++ config.swapDevices;
  encDevs = filter (dev: dev.encrypted.enable) fileSystems;
  keyedEncDevs = filter (dev: dev.encrypted.keyFile != null) encDevs;
  keylessEncDevs = filter (dev: dev.encrypted.keyFile == null) encDevs;
  isIn = needle: haystack: filter (p: p == needle) haystack != [];
  anyEncrypted =
    fold (j: v: v || j.encrypted.enable) false encDevs;

  encryptedFSOptions = {

    encrypted = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "The block device is backed by an encrypted one, adds this device as a initrd luks entry.";
      };

      blkDev = mkOption {
        default = null;
        example = "/dev/sda1";
        type = types.nullOr types.str;
        description = "Location of the backing encrypted device.";
      };

      label = mkOption {
        default = null;
        example = "rootfs";
        type = types.nullOr types.str;
        description = "Label of the unlocked encrypted device. Set <literal>fileSystems.&lt;name?&gt;.device</literal> to <literal>/dev/mapper/&lt;label&gt;</literal> to mount the unlocked device.";
      };

      keyFile = mkOption {
        default = null;
        example = "/root/.swapkey";
        type = types.nullOr types.str;
        description = "File system location of keyfile. This unlocks the drive after the root has been mounted to <literal>/mnt-root</literal>.";
      };
    };
  };
in

{

  options = {
    fileSystems = mkOption {
      options = [encryptedFSOptions];
    };
    swapDevices = mkOption {
      options = [encryptedFSOptions];
    };
  };

  config = mkIf anyEncrypted {
    boot.initrd = {
      luks = {
        devices =
          map (dev: { name = dev.encrypted.label; device = dev.encrypted.blkDev; } ) keylessEncDevs;
        cryptoModules = [ "aes" "sha256" "sha1" "xts" ];
        forceLuksSupportInInitrd = true;
      };
      postMountCommands =
        concatMapStrings (dev: "cryptsetup luksOpen --key-file ${dev.encrypted.keyFile} ${dev.encrypted.blkDev} ${dev.encrypted.label};\n") keyedEncDevs;
    };
  };
}

