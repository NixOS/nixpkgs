{ config, pkgs, modulesPath, ... }:

with pkgs.lib;

let
  fileSystems = attrValues config.fileSystems ++ config.swapDevices;
  encDevs = filter (dev: dev.encrypted.enable) fileSystems;
  keyedEncDevs = filter (dev: dev.encrypted.keyFile != null) encDevs;
  isIn = needle: haystack: filter (p: p == needle) haystack != [];
  anyEncrypted =
    fold (j: v: v || j.encrypted.enable) false encDevs;

  encryptedFSOptions = {

    encrypted = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "The block device is backed by an encrypted one, adds this device as a initrd luks entry";
      };

      blkDev = mkOption {
        default = null;
        example = "/dev/sda1";
        type = types.uniq (types.nullOr types.string);
        description = "Location of the backing encrypted device";
      };

      label = mkOption {
        default = null;
        example = "rootfs";
        type = types.uniq (types.nullOr types.string);
        description = "Label of the backing encrypted device";
      };

      keyFile = mkOption {
        default = null;
        example = "/root/.swapkey";
        type = types.uniq (types.nullOr types.string);
        description = "File system location of keyfile";
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
          map (dev: { name = dev.encrypted.label; device = dev.encrypted.blkDev; } ) encDevs;
        cryptoModules = [ "aes" "sha256" "sha1" "xts" ];
      };
      postMountCommands =
        concatMapStrings (dev: "cryptsetup luksOpen --key-file ${dev.encrypted.keyFile} ${dev.encrypted.label};\n") keyedEncDevs;
    };
  };
}

