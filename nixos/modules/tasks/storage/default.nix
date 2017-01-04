{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption types;
  storageLib = import ./lib.nix { inherit lib; cfg = config.storage; };

  containerTypes = let
    filterFun = lib.const (attrs: attrs.isContainer or false);
  in lib.attrNames (lib.filterAttrs filterFun deviceTypes);

  resizableOptions = deviceSpec: {
    options.size = mkOption {
      type = storageLib.types.size;
      example = { gib = 1; mb = 234; };
      apply = s: if lib.isInt s then { b = s; } else s;
      description = ''
        Size of the ${deviceSpec.description} either as an integer in bytes, an
        attribute set of size units or the special string
        <literal>fill</literal> which uses the remaining size of the target
        device.

        Allowed size units are:
        <variablelist>
          ${lib.concatStrings (lib.mapAttrsToList (size: desc: ''
          <varlistentry>
            <term><option>${size}</option></term>
            <listitem><para>${desc}</para></listitem>
          </varlistentry>
          '') storageLib.sizeUnits)}
        </variablelist>
      '';
    };
  };

  orderableOptions = deviceSpec: {
    options.before = mkOption {
      type = types.listOf (storageLib.types.deviceSpec [ deviceSpec.name ]);
      default = [];
      description = ''
        List of ${deviceSpec.description}s that will be created after this
        ${deviceSpec.description}.
      '';
    };

    options.after = mkOption {
      type = types.listOf (storageLib.types.deviceSpec [ deviceSpec.name ]);
      default = [];
      description = ''
        List of ${deviceSpec.description}s that will be created prior to this
        ${deviceSpec.description}.
      '';
    };
  };

  partitionOptions.options = {
    targetDevice = mkOption {
      type = storageLib.types.deviceSpec containerTypes;
      description = ''
        The target device of this partition.
      '';
    };
  };

  mdraidOptions.options = {
    level = mkOption {
      type = types.int;
      default = 1;
      description = ''
        RAID level, default is 1 for mirroring.
      '';
    };

    devices = mkOption {
      type = types.listOf (storageLib.types.deviceSpec containerTypes);
      description = ''
        List of devices that will be part of this array.
      '';
    };
  };

  volgroupOptions.options = {
    devices = mkOption {
      type = types.listOf (storageLib.types.deviceSpec containerTypes);
      description = ''
        List of devices that will be part of this volume group.
      '';
    };
  };

  logvolOptions.options = {
    group = mkOption {
      type = storageLib.types.deviceSpec [ "volgroup" ];
      description = ''
        The volume group this volume should be part of.
      '';
    };
  };

  btrfsOptions.options = {
    devices = mkOption {
      type = types.listOf (storageLib.types.deviceSpec containerTypes);
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

  deviceTypes = {
    disk = {
      description = "disk";
      isContainer = true;
      options = import ./disk.nix { inherit pkgs; };
    };
    partition = {
      description = "disk partition";
      isContainer = true;
      orderable = true;
      resizable = true;
      options = partitionOptions;
    };
    mdraid = {
      description = "MD RAID device";
      isContainer = true;
      orderable = true;
      options = mdraidOptions;
    };
    volgroup = {
      description = "LVM volume group";
      options = volgroupOptions;
    };
    logvol = {
      description = "LVM logical volume";
      isContainer = true;
      orderable = true;
      resizable = true;
      options = logvolOptions;
    };
    btrfs = {
      description = "BTRFS volume";
      options = btrfsOptions;
    };
  };

  # Return true if an option is referencing a btrfs storage specification.
  isBtrfs = storage: lib.isString storage && lib.hasPrefix "btrfs." storage;

  # Make sure that whenever a fsType is set to something different than "btrfs"
  # while using a "btrfs" device spec type we throw an assertion error.
  assertions = lib.mapAttrsToList (fs: cfg: {
    assertion = if isBtrfs cfg.storage then cfg.fsType == "btrfs" else true;
    message = "The option `fileSystems.${fs}.fsType' is `${cfg.fsType}' but"
            + " \"btrfs\" is expected because `fileSystems.${fs}.storage'"
            + " is set to `${cfg.storage}'.";
  }) config.fileSystems;

in

{
  options.storage = lib.mapAttrs (devType: attrs: mkOption {
    type = let
      deviceSpec = attrs // { name = devType; };
      orderable = attrs.orderable or false;
      resizable = attrs.resizable or false;
    in types.attrsOf (types.submodule {
      imports = lib.singleton attrs.options
             ++ lib.optional orderable (orderableOptions deviceSpec)
             ++ lib.optional resizable (resizableOptions deviceSpec);
    });
    default = {};
    description = "Storage configuration for a ${attrs.description}."
                + lib.optionalString (attrs ? doc) "\n\n${attrs.doc}";
  }) deviceTypes;

  options.fileSystems = mkOption {
    type = types.loaOf (types.submodule ({ config, ... }: {
      options.storage = mkOption {
        default = null;
        example = "partition.root";
        type = types.nullOr (storageLib.types.deviceSpec (containerTypes ++ [
          "btrfs"
        ]));
        description = ''
          Storage device from <option>storage.*</option> to use for
          this file system.
        '';
      };

      # If a fileSystems submodule references "btrfs." via the storage option,
      # set the default value for fsType to "btrfs".
      config = lib.mkIf (isBtrfs config.storage) {
        fsType = lib.mkDefault "btrfs";
      };
    }));
  };

  options.swapDevices = mkOption {
    type = types.listOf (types.submodule {
      options.storage = mkOption {
        default = null;
        example = "partition.swap";
        type = types.nullOr (storageLib.types.deviceSpec containerTypes);
        description = ''
          Storage device from <option>storage.*</option> to use for
          this swap device.
        '';
      };
    });
  };

  config = {
    inherit assertions;
    system.build.nixpart-spec = let
      # Only check assertions for this module.
      failed = map (x: x.message) (lib.filter (x: !x.assertion) assertions);
      failedStr = lib.concatMapStringsSep "\n" (x: "- ${x}") failed;
    in pkgs.writeText "nixpart.json" (if failed == [] then builtins.toJSON {
      inherit (config) fileSystems swapDevices storage;
    } else throw "\nFailed assertions:\n${failedStr}");
  };
}
