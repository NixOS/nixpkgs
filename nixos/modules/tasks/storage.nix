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

  /* Return a string enumerating the list of `valids' in a way to be more
   * friendly to human readers.
   *
   * For example if the list is [ "a" "b" "c" ] the result is:
   *
   *   "one of `a', `b' or `c'"
   *
   * If `valids' contains only two elements, like [ "a" "b" ] the result is:
   *
   *   "either `a' or `b'"
   *
   * If `valids' is a singleton list, like [ "lonely" ] the result is:
   *
   *   "`lonely'"
   *
   * Note that it is expected that `valids' is non-empty and no extra
   * checking is done to show a reasonable error message if that's the
   * case.
   */
  oneOf = valids: let
    inherit (lib) head init last;
    quote = name: "`${name}'";
    len = builtins.length valids;
    two = "either ${quote (head valids)} or ${quote (last valids)}";
    multi = "one of " + lib.concatMapStringsSep ", " quote (init valids)
          + " or ${quote (last valids)}";
  in if len > 2 then multi else if len == 2 then two else quote (head valids);

  /* Make sure that the size units defined in a size type are correct.
   *
   * We can have simple `{ kb = 123; }' size units but also multiple size units,
   * like this:
   *
   *   { b = 100; kb = 200; mib = 300; yib = 400; }
   *
   * This function returns true or false depending on whether the unit size type
   * is correct or not. If it's incorrect, builtins.trace is used to print a
   * more helpful error message than the generic one we get from the NixOS
   * module system.
   */
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

  /* Validate the device specification and return true if it's valid or false if
   * it's not.
   *
   * As with assertUnits, builtins.trace is used to print an additional error
   * message. TODO: Check device name!
   */
  assertSpec = validTypes: spec: let
    syntaxErrorMsg =
      "Device specification \"${spec}\" needs to be in the form " +
      "`<type>.<name>', where `name' may only contain letters (lower and " +
      "upper case), numbers, underscores (_) and dashes (-)";
    invalidTypeMsg =
      "Device type `${lib.head typeAndName}' is invalid and needs to be " +
      "${oneOf validTypes}.";
    syntaxError = builtins.trace syntaxErrorMsg false;
    typeAndName = builtins.match "([a-z]+)\\.([a-zA-Z0-9_-]+)" spec;
    assertType = if lib.elem (lib.head typeAndName) validTypes then true
                 else builtins.trace invalidTypeMsg false;
  in if typeAndName == null then syntaxError else assertType;

  deviceSpecType = validTypes: lib.mkOptionType {
    name = "deviceSpec";
    description = "device specification of <type>.<name>";
    check = spec: lib.isString spec && assertSpec validTypes spec;
    merge = lib.mergeEqualOption;
  };

  containerTypes = let
    filterFun = lib.const (attrs: attrs.isContainer or false);
  in lib.attrNames (lib.filterAttrs filterFun deviceTypes);

  resizableOptions = deviceSpec: {
    options.size = mkOption {
      type = sizeType;
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
          '') sizeUnits)}
        </variablelist>
      '';
    };
  };

  orderableOptions = deviceSpec: {
    options.before = mkOption {
      type = types.listOf (deviceSpecType [ deviceSpec.name ]);
      default = [];
      description = ''
        List of ${deviceSpec.description}s that will be created after this
        ${deviceSpec.description}.
      '';
    };

    options.after = mkOption {
      type = types.listOf (deviceSpecType [ deviceSpec.name ]);
      default = [];
      description = ''
        List of ${deviceSpec.description}s that will be created prior to this
        ${deviceSpec.description}.
      '';
    };
  };

  partitionOptions.options = {
    targetDevice = mkOption {
      type = deviceSpecType containerTypes;
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
      type = types.listOf (deviceSpecType containerTypes);
      description = ''
        List of devices that will be part of this array.
      '';
    };
  };

  volgroupOptions.options = {
    devices = mkOption {
      type = types.listOf (deviceSpecType containerTypes);
      description = ''
        List of devices that will be part of this volume group.
      '';
    };
  };

  logvolOptions.options = {
    group = mkOption {
      type = deviceSpecType [ "volgroup" ];
      description = ''
        The volume group this volume should be part of.
      '';
    };
  };

  btrfsOptions.options = {
    devices = mkOption {
      type = types.listOf (deviceSpecType containerTypes);
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

  deviceTypes = {
    disk = {
      description = "disk";
      isContainer = true;
      options = diskOptions;
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
    description = "Storage configuration for a ${attrs.description}.";
  }) deviceTypes;

  options.fileSystems = mkOption {
    type = types.loaOf (types.submodule {
      options.storage = mkOption {
        default = null;
        example = "partition.root";
        type = types.nullOr types.str;
        description = ''
          Storage device from <option>storage.*</option> to use for
          this file system.
        '';
      };
    });
  };

  options.swapDevices = mkOption {
    type = types.listOf (types.submodule {
      options.storage = mkOption {
        default = null;
        example = "partition.swap";
        type = types.nullOr types.str;
        description = ''
          Storage device from <option>storage.*</option> to use for
          this swap device.
        '';
      };
    });
  };
}
