{ lib, ... }:

let
  inherit (lib) mkOption types;

  sizeUnits = {
    b = "byte";
    kib = "kibibyte";
    mib = "mebibyte";
    gib = "gibibyte";
    tib = "tebibyte";
    pib = "pebibyte";
    eib = "exbibyte";
    zib = "zebibyte";
    yib = "yobibyte";
    kb = "kilobyte";
    mb = "megabyte";
    gb = "gigabyte";
    tb = "terabyte";
    pb = "petabyte";
    eb = "exabyte";
    zb = "zettabyte";
    yb = "yottabyte";
  };

  assertUnits = attrs: let
    quoteUnit = unit: "`${unit}'";
    unitList = lib.attrNames sizeUnits;
    validStr = lib.concatMapStringsSep ", " quoteUnit (lib.init unitList)
             + " or ${quoteUnit (lib.last unitList)}";
    errSize = unit: "Size for ${quoteUnit unit} has to be an integer.";
    errUnit = unit: "Unit ${quoteUnit unit} is not valid, "
                  + "it has to be one of ${validStr}.";
    errEmpty = "Size units attribute set cannot be empty.";
    assertSize = unit: size: lib.optional (!lib.isInt size) (errSize unit);
    assertUnit = unit: size: if sizeUnits ? ${unit} then assertSize unit size
                             else lib.singleton (errUnit unit);
    assertions = if attrs == {} then lib.singleton errEmpty
                 else lib.flatten (lib.mapAttrsToList assertUnit attrs);
    strAssertions = lib.concatStringsSep "\n" (assertions);
  in if assertions == [] then true else builtins.trace strAssertions false;

  sizeType = lib.mkOptionType {
    name = "size";
    description = "\"fill\", integer in bytes or attrset of unit -> size";
    check = s: s == "fill" || lib.isInt s || (lib.isAttrs s && assertUnits s);
    merge = lib.mergeEqualOption;
  };

  deviceType = types.str;
  volgroupType = types.str;

  commonOptions = {
    size = mkOption {
      type = sizeType;
      example = { gib = 1; mb = 234; };
      apply = s: if lib.isInt s then { b = s; } else s;
      description = ''
        Size of the partition either as an integer in bytes, an attribute set of
        size units or the special string <literal>fill</iiteral> which uses the
        remaining size of the target device.

        Allowed size units are:
        <variablelist>
          ${lib.concatStrings (lib.mapAttrsToList (size: desc: ''
          <varlistentry>
            <term><option>${size}</option></term>
            <listitem><para>${desc}</para></listitem>
          </varlistentry>
          '') sizeUnits)}
        </variablelist>
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

  btrfsOptions.options = {
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

  diskOptions = { config, ... }: {
    options = {
      clear = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Clear the partition table of this device.
        '';
      };

      initlabel = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Create a new disk label for this device (implies
          <option>clear</option>).
        '';
      };
    };

    config = lib.mkIf config.initlabel {
      clear = true;
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
