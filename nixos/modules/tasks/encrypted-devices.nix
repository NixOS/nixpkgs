{ config, lib, ... }:

with lib;

let
  fileSystems = config.system.build.fileSystems ++ config.swapDevices;
  encDevs = filter (dev: dev.encrypted.enable) fileSystems;

  # With scripted initrd, devices with a keyFile have to be opened
  # late, after file systems are mounted, because that could be where
  # the keyFile is located. With systemd initrd, each individual
  # systemd-cryptsetup@ unit has RequiresMountsFor= to delay until all
  # the mount units for the key file are done; i.e. no special
  # treatment is needed.
  lateEncDevs =
    if config.boot.initrd.systemd.enable
    then { }
    else filter (dev: dev.encrypted.keyFile != null) encDevs;
  earlyEncDevs =
    if config.boot.initrd.systemd.enable
    then encDevs
    else filter (dev: dev.encrypted.keyFile == null) encDevs;

  anyEncrypted =
    foldr (j: v: v || j.encrypted.enable) false encDevs;

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
        assertion =
          config.boot.initrd.systemd.enable -> (
            dev.encrypted.keyFile == null
            || !lib.any (x: lib.hasPrefix x dev.encrypted.keyFile) ["/mnt-root" "$targetRoot"]
          );
        message = ''
          Bad use of '/mnt-root' or '$targetRoot` in 'keyFile'.

            When 'boot.initrd.systemd.enable' is enabled, file systems
            are mounted at '/sysroot' instead of '/mnt-root'.
        '';
      }
    ]) encDevs;

    boot.initrd = {
      luks = {
        devices =
          builtins.listToAttrs (map (dev: {
            name = dev.encrypted.label;
            value = { device = dev.encrypted.blkDev; inherit (dev.encrypted) keyFile; };
          }) earlyEncDevs);
        forceLuksSupportInInitrd = true;
      };
      # TODO: systemd stage 1
      postMountCommands = lib.mkIf (!config.boot.initrd.systemd.enable)
        (concatMapStrings (dev:
          "cryptsetup luksOpen --key-file ${dev.encrypted.keyFile} ${dev.encrypted.blkDev} ${dev.encrypted.label};\n"
        ) lateEncDevs);
    };
  };
}
