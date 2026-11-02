{ config, lib, ... }:

with lib;

let
  fileSystems = config.system.build.fileSystems ++ config.swapDevices;
  encDevs = filter (dev: dev.encrypted.enable) fileSystems;

  anyEncrypted = foldr (j: v: v || j.encrypted.enable) false encDevs;

  encryptedFSOptions = {

    options.encrypted = {
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
        description = "Label of the unlocked encrypted device. Set `fileSystems.<name?>.device` to `/dev/mapper/<label>` to mount the unlocked device.";
      };

      keyFile = mkOption {
        default = null;
        example = "/mnt-root/root/.swapkey";
        type = types.nullOr types.str;
        description = ''
          Path to a keyfile used to unlock the backing encrypted
          device. When systemd stage 1 is not enabled, at the time
          this keyfile is accessed, the `neededForBoot` filesystems
          (see `utils.fsNeededForBoot`) will have been mounted under
          `/mnt-root`, so the keyfile path should usually start with
          "/mnt-root/". When systemd stage 1 is enabled,
          `fsNeededForBoot` file systems will be mounted as needed
          under `/sysroot`, and the keyfile will not be accessed until
          its requisite mounts are done.
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
    assertions = concatMap (dev: [
      {
        assertion = dev.encrypted.label != null;
        message = ''
          The filesystem for ${dev.mountPoint} has encrypted.enable set to true, but no encrypted.label set
        '';
      }
      {
        assertion = (
          dev.encrypted.keyFile == null
          || !lib.any (x: lib.hasPrefix x dev.encrypted.keyFile) [
            "/mnt-root"
            "$targetRoot"
          ]
        );
        message = ''
          Bad use of '/mnt-root' or '$targetRoot` in 'keyFile'.

            File systems are mounted at '/sysroot' instead of '/mnt-root'.

        '';
      }
    ]) encDevs;

    boot.initrd = {
      luks = {
        devices = builtins.listToAttrs (
          map (dev: {
            name = dev.encrypted.label;
            value = {
              device = dev.encrypted.blkDev;
              inherit (dev.encrypted) keyFile;
            };
          }) encDevs
        );
        forceLuksSupportInInitrd = true;
      };
    };
  };
}
