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

  genericOptions = deviceSpec: { name, ... }: {
    options.uuid = mkOption {
      internal = true;
      description = ''
        The UUID of this device specification used for device formats, such as
        file systems and other containers.

        This is a generated value and shouldn't be set outside of this module.
        It identifies the same device from within nixpart and from within a
        NixOS system for mounting.

        By default, every file system gets a random UUID, but we need to have
        this deterministic so that we always get the same UUID for the same
        device specification. So we hash the full device specification (eg.
        <literal>partition.foo</literal>) along with a
        <literal>nixpart</literal> namespace with sha1 and truncate it to 128
        bits, similar to version 5 of the UUID specification:

        <link xlink:href="https://tools.ietf.org/html/rfc4122#section-4.1.3"/>

        Note that instead of a binary namespace ID, we simply use string
        concatenation in the form of
        <literal>[namespace]:[spectype].[specname]</literal>, so for example the
        device specification of <literal>partition.foo</literal> gets a hash
        from <literal>nixpart:partition.foo</literal>.
      '';
    };
    config.uuid = let
      inherit (builtins) hashString substring;
      baseHash = hashString "sha1" "nixpart:${deviceSpec.name}.${name}";
      splitted = [
        (substring 0 8 baseHash)
        (substring 8 4 baseHash)
        (substring 12 4 baseHash)
        (substring 16 4 baseHash)
        (substring 20 12 baseHash)
      ];
    in lib.concatStringsSep "-" splitted;
  };

  orderableOptions = deviceSpec: {
    options.before = storageLib.mkDeviceSpecOption {
      typeContainer = types.listOf;
      applyTypeContainer = map;
      validDeviceTypes = [ deviceSpec.name ];
      default = [];
      description = ''
        List of ${deviceSpec.description}s that will be created after this
        ${deviceSpec.description}.
      '';
    };

    options.after = storageLib.mkDeviceSpecOption {
      typeContainer = types.listOf;
      applyTypeContainer = map;
      validDeviceTypes = [ deviceSpec.name ];
      default = [];
      description = ''
        List of ${deviceSpec.description}s that will be created prior to this
        ${deviceSpec.description}.
      '';
    };
  };

  partitionOptions.options = {
    targetDevice = storageLib.mkDeviceSpecOption {
      validDeviceTypes = containerTypes;
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

    devices = storageLib.mkDeviceSpecOption {
      typeContainer = types.listOf;
      applyTypeContainer = map;
      validDeviceTypes = containerTypes;
      description = ''
        List of devices that will be part of this array.
      '';
    };
  };

  volgroupOptions.options = {
    devices = storageLib.mkDeviceSpecOption {
      typeContainer = types.listOf;
      applyTypeContainer = map;
      validDeviceTypes = containerTypes;
      description = ''
        List of devices that will be part of this volume group.
      '';
    };
  };

  logvolOptions.options = {
    group = storageLib.mkDeviceSpecOption {
      validDeviceTypes = [ "volgroup" ];
      description = ''
        The volume group this volume should be part of.
      '';
    };
  };

  btrfsOptions.options = {
    devices = storageLib.mkDeviceSpecOption {
      typeContainer = types.listOf;
      applyTypeContainer = map;
      validDeviceTypes = containerTypes;
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

  assertions = let
    # Make sure that whenever a fsType is set to something different than
    # "btrfs" while using a "btrfs" device spec type we throw an assertion
    # error.
    btrfsAssertions = lib.mapAttrsToList (fs: cfg: {
      assertion = if isBtrfs cfg.storage then cfg.fsType == "btrfs" else true;
      message = "The option `fileSystems.${fs}.fsType' is `${cfg.fsType}' but"
              + " \"btrfs\" is expected because `fileSystems.${fs}.storage'"
              + " is set to `${cfg.storage}'.";
    }) config.fileSystems;

    # Only allow one match method to be set for a disk and throw an assertion
    # if either no match methods or too many (more than one) are defined.
    matcherAssertions = lib.mapAttrsToList (disk: cfg: let
      inherit (lib) attrNames filterAttrs;
      isMatcher = name: name != "_module" && name != "allowIncomplete";
      filterMatcher = name: val: isMatcher name && val != null;
      defined = attrNames (filterAttrs filterMatcher cfg.match);
      amount = lib.length defined;
      optStr = "`storage.disk.${disk}'";
      noneMsg = "No match methods have been defined for ${optStr}.";
      manyMsg = "The disk ${optStr} has more than one match methods"
              + " defined: ${lib.concatStringsSep ", " defined}";
    in {
      assertion = amount == 1;
      message = if amount < 1 then noneMsg else manyMsg;
    }) config.storage.disk;

  in btrfsAssertions ++ matcherAssertions;

in

{
  options.storage = lib.mapAttrs (devType: attrs: mkOption {
    type = let
      deviceSpec = attrs // { name = devType; };
      orderable = attrs.orderable or false;
      resizable = attrs.resizable or false;
    in types.attrsOf (types.submodule {
      imports = [ attrs.options (genericOptions deviceSpec) ]
             ++ lib.optional orderable (orderableOptions deviceSpec)
             ++ lib.optional resizable (resizableOptions deviceSpec);
    });
    default = {};
    description = "Storage configuration for a ${attrs.description}."
                + lib.optionalString (attrs ? doc) "\n\n${attrs.doc}";
  }) deviceTypes;

  options.fileSystems = mkOption {
    type = types.loaOf (types.submodule ({ config, ... }: {
      options.storage = storageLib.mkDeviceSpecOption {
        validDeviceTypes = containerTypes ++ [ "btrfs" ];
        typeContainer = types.nullOr;
        applyTypeContainer = fun: val: if val == null then null else fun val;
        default = null;
        example = "partition.root";
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
      options.storage = storageLib.mkDeviceSpecOption {
        validDeviceTypes = containerTypes;
        typeContainer = types.nullOr;
        applyTypeContainer = fun: val: if val == null then null else fun val;
        default = null;
        example = "partition.swap";
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
