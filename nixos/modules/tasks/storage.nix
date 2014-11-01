{ lib, ... }:

with lib;

let
  sizeType = types.either types.int types.str;
  deviceType = types.str;

  commonOptions = {
    grow = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Grow the partition to the remaining size of the target device.
      '';
    };

    size = mkOption {
      type = types.nullOr sizeType;
      default = null;
      description = ''
        Size of the partition either as an integer in megabytes or
        as a string with a size multiplier suffix (M, G, T, ...).
      '';
    };

    before = mkOption {
      type = types.listOf deviceType;
      default = [];
      description = ''
        List of devices/partitions that will be created
        after this partition.
      '';
    };

    after = mkOption {
      type = types.listOf deviceType;
      default = [];
      description = ''
        List of devices/partitions that will be created
        prior to this partition.
      '';
    };
  };

  partitionOptions.options = commonOptions // {
    targetDevice = mkOption {
      type = deviceType;
      description = ''
        The target device of this partition.
      '';
    };
  };

  mdraidOptions.options = commonOptions // {
    level = mkOption {
      type = types.int;
      default = 1;
      description = ''
        RAID level, default is 1 for mirroring.
      '';
    };

    devices = mkOption {
      type = types.listOf deviceType;
      description = ''
        List of devices that will be part of this array.
      '';
    };
  };

  volgroupOptions.options = commonOptions // {
    devices = mkOption {
      type = types.listOf deviceType;
      description = ''
        List of devices that will be part of this volume group.
      '';
    };
  };

  logvolOptions.options = commonOptions // {
    group = mkOption {
      type = volgroupType;
      description = ''
        The volume group this volume should be part of.
      '';
    };
  };

  btrfsOptions.options = commonOptions // {
    devices = mkOption {
      type = types.listOf deviceType;
      description = ''
        List of devices that will be part of this BTRFS volume.
      '';
    };

    data = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        RAID level to use for filesystem data.
      '';
    };

    metadata = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        RAID level to use for filesystem metadata.
      '';
    };
  };

  diskOptions.options = {
    clear = mkOption {
      type = types.bool;
      description = ''
        Clear the partition table of this device.
      '';
    };

    initlabel = mkOption {
      type = types.bool;
      description = ''
        Create a new disk label for this device (implies
        <option>clear</option>).
      '';
    };
  };

in

{
  options.storage = {
    partition = mkOption {
      type = types.attrsOf (types.submodule partitionOptions);
      default = {};
      description = ''
        Storage configuration for a disk partition.
      '';
    };

    mdraid = mkOption {
      type = types.attrsOf (types.submodule mdraidOptions);
      default = {};
      description = ''
        Storage configuration for a RAID device.
      '';
    };

    volgroup = mkOption {
      type = types.attrsOf (types.submodule volgroupOptions);
      default = {};
      description = ''
        Storage configuration for a LVM volume group.
      '';
    };

    logvol = mkOption {
      type = types.attrsOf (types.submodule logvolOptions);
      default = {};
      description = ''
        Storage configuration for a LVM logical volume.
      '';
    };

    btrfs = mkOption {
      type = types.attrsOf (types.submodule btrfsOptions);
      default = {};
      description = ''
        Storage configuration for a BTRFS volume.
      '';
    };

    disk = mkOption {
      type = types.attrsOf (types.submodule diskOptions);
      default = {};
      description = ''
        Storage configuration for a disk.
      '';
    };
  };
}
