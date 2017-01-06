{ lib ? import ../../../../lib
# This is the value of config.storage and it's needed to look up valid device
# specifications.
, cfg ? {}
}:

let
  # A map of valid size units (attribute name) to their descriptions.
  sizeUnits = {
    b = "byte";
    kib = "kibibyte (1024 bytes)";
    mib = "mebibyte (1024 kibibytes)";
    gib = "gibibyte (1024 mebibytes)";
    tib = "tebibyte (1024 gibibytes)";
    pib = "pebibyte (1024 tebibytes)";
    eib = "exbibyte (1024 pebibytes)";
    zib = "zebibyte (1024 exbibytes)";
    yib = "yobibyte (1024 zebibytes)";
    kb = "kilobyte (1000 bytes)";
    mb = "megabyte (1000 kilobytes)";
    gb = "gigabyte (1000 megabytes)";
    tb = "terabyte (1000 gigabytes)";
    pb = "petabyte (1000 terabytes)";
    eb = "exabyte (1000 petabytes)";
    zb = "zettabyte (1000 exabytes)";
    yb = "yottabyte (1000 zettabytes)";
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

  /* Decode a device specification string like "partition.foo" into an attribute
   * set consisting of the attributes `type' ("partition" here) and `name'
   * ("foo" here).
   */
  decodeSpec = spec: let
    typeAndName = builtins.match "([a-z]+)\\.([a-zA-Z0-9_-]+)" spec;
  in if typeAndName == null then null else {
    type = lib.head typeAndName;
    name = lib.last typeAndName;
  };

  /* Validate the device specification and return true if it's valid or false if
   * it's not.
   *
   * As with assertUnits, builtins.trace is used to print an additional error
   * message.
   */
  assertSpec = validTypes: spec: let
    syntaxErrorMsg =
      "Device specification \"${spec}\" needs to be in the form " +
      "`<type>.<name>', where `name' may only contain letters (lower and " +
      "upper case), numbers, underscores (_) and dashes (-)";
    invalidTypeMsg =
      "Device type `${type}' is invalid and needs to be ${oneOf validTypes}.";
    invalidNameMsg =
      "Device `${type}.${name}' does not exist in `config.storage.*'.";
    syntaxError = builtins.trace syntaxErrorMsg false;
    decoded = decodeSpec spec;
    inherit (decoded) type name;
    assertName = if (cfg.${type} or {}) ? ${name} then true
                 else builtins.trace invalidNameMsg false;
    assertType = if lib.elem type validTypes then assertName
                 else builtins.trace invalidTypeMsg false;
  in if decoded == null then syntaxError else assertType;

  deviceSpecType = validTypes: lib.mkOptionType {
    name = "deviceSpec";
    description = "device specification";
    check = spec: lib.isString spec && assertSpec validTypes spec;
    merge = lib.mergeEqualOption;
  };

in {
  inherit sizeUnits;

  mkDeviceSpecOption = attrs: lib.mkOption ({
    type = let
      # This is a list of valid device types in a device specification, such as
      # "partition", "disk" and so on.
      validDeviceTypes = attrs.validDeviceTypes or [];
      # The outer type wrapping the internal deviceSpecType, so it's possible to
      # wrap the deviceSpecType in any other container type in lib.types.
      typeContainer = attrs.typeContainer or lib.id;
    in typeContainer (deviceSpecType validDeviceTypes);
    # `applyTypeContainer' is a function that's used to unpack the individual
    # deviceSpecType from the typeContainer. So for example if typeContainer is
    # `listOf', the applyTypeContainer function is "map".
    apply = (attrs.applyTypeContainer or lib.id) decodeSpec;
    description = attrs.description + ''
      The device specification has to be in the form
      <literal>&lt;type&gt;.&lt;name&gt;</literal> where <literal>type</literal>
      is ${oneOf (attrs.validDeviceTypes or [])} and <literal>name</literal> is
      the name in <option>storage.sometype.name</option>.
    '';
  } // removeAttrs attrs [
    "validDeviceTypes" "typeContainer" "applyTypeContainer" "description"
  ]);

  types = {
    size = lib.mkOptionType {
      name = "size";
      description = "\"fill\", integer in bytes or attrset of unit -> size";
      check = s: s == "fill" || lib.isInt s || (lib.isAttrs s && assertUnits s);
      merge = lib.mergeEqualOption;
    };
  };
}
