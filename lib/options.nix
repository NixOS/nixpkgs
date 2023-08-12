# Nixpkgs/NixOS option handling.
{ lib }:

let
  inherit (lib)
    all
    collect
    concatLists
    concatMap
    concatMapStringsSep
    filter
    foldl'
    head
    isAttrs
    isBool
    isDerivation
    isFunction
    isInt
    isList
    isString
    length
    mapAttrs
    optional
    optionals
    tail
    take
    ;
  inherit (lib.attrsets)
    attrByPath
    attrNames
    attrValues
    optionalAttrs
    ;
  inherit (lib.strings)
    concatMapStrings
    concatStringsSep
    ;
  inherit (lib.types)
    mkOptionType
    ;
  inherit (lib.lists)
    last
    ;
  prioritySuggestion = ''
   Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  '';
in
rec {

  /* Returns true when the given argument is an option

     Type: isOption :: a -> bool

     Example:
       isOption 1             // => false
       isOption (mkOption {}) // => true
  */
  isOption = lib.isType "option";

  /* Creates an Option attribute set. mkOption accepts an attribute set with the following keys:

     All keys default to `null` when not given.

     Example:
       mkOption { }  // => { _type = "option"; }
       mkOption { default = "foo"; } // => { _type = "option"; default = "foo"; }
  */
  mkOption =
    {
    # Default value used when no definition is given in the configuration.
    default ? null,
    # Textual representation of the default, for the manual.
    defaultText ? null,
    # Example value used in the manual.
    example ? null,
    # String describing the option.
    description ? null,
    # Related packages used in the manual (see `genRelatedPackages` in ../nixos/lib/make-options-doc/default.nix).
    relatedPackages ? null,
    # Option type, providing type-checking and value merging.
    type ? null,
    # Function that converts the option value to something else.
    apply ? null,
    # Whether the option is for NixOS developers only.
    internal ? null,
    # Whether the option shows up in the manual. Default: true. Use false to hide the option and any sub-options from submodules. Use "shallow" to hide only sub-options.
    visible ? null,
    # Whether the option can be set only once
    readOnly ? null,
    } @ attrs:
    attrs // { _type = "option"; };

  /* Creates an Option attribute set for a boolean value option i.e an
     option to be toggled on or off:

     Example:
       mkEnableOption "foo"
       => { _type = "option"; default = false; description = "Whether to enable foo."; example = true; type = { ... }; }
  */
  mkEnableOption =
    # Name for the created option
    name: mkOption {
    default = false;
    example = true;
    description = "Whether to enable ${name}.";
    type = lib.types.bool;
  };

  /* Creates an Option attribute set for an option that specifies the
     package a module should use for some purpose.

     The package is specified in the third argument under `default` as a list of strings
     representing its attribute path in nixpkgs (or another package set).
     Because of this, you need to pass nixpkgs itself (or a subset) as the first argument.

     The second argument may be either a string or a list of strings.
     It provides the display name of the package in the description of the generated option
     (using only the last element if the passed value is a list)
     and serves as the fallback value for the `default` argument.

     To include extra information in the description, pass `extraDescription` to
     append arbitrary text to the generated description.
     You can also pass an `example` value, either a literal string or an attribute path.

     The default argument can be omitted if the provided name is
     an attribute of pkgs (if name is a string) or a
     valid attribute path in pkgs (if name is a list).

     If you wish to explicitly provide no default, pass `null` as `default`.

     Type: mkPackageOption :: pkgs -> (string|[string]) -> { default? :: [string], example? :: null|string|[string], extraDescription? :: string } -> option

     Example:
       mkPackageOption pkgs "hello" { }
       => { _type = "option"; default = «derivation /nix/store/3r2vg51hlxj3cx5vscp0vkv60bqxkaq0-hello-2.10.drv»; defaultText = { ... }; description = "The hello package to use."; type = { ... }; }

     Example:
       mkPackageOption pkgs "GHC" {
         default = [ "ghc" ];
         example = "pkgs.haskell.packages.ghc92.ghc.withPackages (hkgs: [ hkgs.primes ])";
       }
       => { _type = "option"; default = «derivation /nix/store/jxx55cxsjrf8kyh3fp2ya17q99w7541r-ghc-8.10.7.drv»; defaultText = { ... }; description = "The GHC package to use."; example = { ... }; type = { ... }; }

     Example:
       mkPackageOption pkgs [ "python39Packages" "pytorch" ] {
         extraDescription = "This is an example and doesn't actually do anything.";
       }
       => { _type = "option"; default = «derivation /nix/store/gvqgsnc4fif9whvwd9ppa568yxbkmvk8-python3.9-pytorch-1.10.2.drv»; defaultText = { ... }; description = "The pytorch package to use. This is an example and doesn't actually do anything."; type = { ... }; }

  */
  mkPackageOption =
    # Package set (a specific version of nixpkgs or a subset)
    pkgs:
      # Name for the package, shown in option description
      name:
      {
        # Whether the package can be null, for example to disable installing a package altogether.
        nullable ? false,
        # The attribute path where the default package is located (may be omitted)
        default ? name,
        # A string or an attribute path to use as an example (may be omitted)
        example ? null,
        # Additional text to include in the option description (may be omitted)
        extraDescription ? "",
      }:
      let
        name' = if isList name then last name else name;
      in mkOption ({
        type = with lib.types; (if nullable then nullOr else lib.id) package;
        description = "The ${name'} package to use."
          + (if extraDescription == "" then "" else " ") + extraDescription;
      } // (if default != null then let
        default' = if isList default then default else [ default ];
        defaultPath = concatStringsSep "." default';
        defaultValue = attrByPath default'
          (throw "${defaultPath} cannot be found in pkgs") pkgs;
      in {
        default = defaultValue;
        defaultText = literalExpression ("pkgs." + defaultPath);
      } else if nullable then {
        default = null;
      } else { }) // lib.optionalAttrs (example != null) {
        example = literalExpression
          (if isList example then "pkgs." + concatStringsSep "." example else example);
      });

  /* Alias of mkPackageOption. Previously used to create options with markdown
     documentation, which is no longer required.
  */
  mkPackageOptionMD = mkPackageOption;

  /* Creates a suggestion based resource namespace allocator.

    It allows someone to define a value space, like a port interval, so other
    modules can "ask" for a value and the module will check for missing values,
    conflicts and invalid candidates and suggest values for these cases that
    must be explicitly set.

    See RFC 0159 for more specification details.

    Example:
     with lib; mkAllocatorModule {
      # dontThrow = true;
      keyPath = "networking.ports";

      valueKey = "port";
      valueType = types.port;
      cfg = config.networking.ports;
      description = "Build time port allocations for services that are only used internally";
      enableDescription = name: "Enable automatic port allocation for service ${name}";
      valueDescription = name: "Allocated port for service ${name}";

      firstValue = 49151;
      succFunc = x: x - 1;
      valueLiteral = toString;
      validateFunc = x: (types.port.check x) && (x > 1024);
      example = literalExpression ''{
        app = {
          enable = true;
          port = 42069; # guided
        };
      }'';
    }
    => { _type = "option"; apply = «lambda @ /nix/store/8dq1grzr2g9ghh8nrwh15mn65pnp9qb1-source/lib/options.nix:309:13»; default = { ... }; description = "Build time port allocations for services that are only used internally"; example = { ... }; internal = null; relatedPackages = null; type = { ... }; visible = null; }
  */
  mkAllocatorModule = {
    # <!-- begin of passthru parameters to the outer mkOption -->
    # `example` parameter passed to the outer mkOption
    example ? null,
    # `internal` parameter passed to the outer mkOption
    internal ? null,
    # `relatedPackages` parameter passed to the outer mkOption
    relatedPackages ? null,
    # `visible` parameter passed to the outer mkOption
    visible ? null,
    # `description` parameter passed to the outer mkOption
    description ? null,
    # <!-- end of passthru parameters to the outer mkOption -->

    # <!-- begin of passthru parameters to the inner mkOption -->
    # Description of one of the items. Can also be a function that gets the
    # item <name> and returs a string
    enableDescription ? "Enable allocation of * undefined item *",

    # `description` parameter passed to the item mkOption
    valueDescription ? "Allocated value for * undefined item *",

    # `type` parameter passed to the item mkOption
    valueType ? null,

    # `apply` parameter passed to the item mkOption
    valueApply ? null,
    # <!-- end of passthru parameters to the inner mkOption -->

    # <!-- begin of user friendliness parameters -->
    # how to convert one item value to a user friendly string
    # representation
    valueLiteral ? value: ''"${keyFunc value}"'',

    # the config parameter but based on the options being defined
    # same idea as that cfg in a let expression in other modules
    cfg,

    # module key path to the generated module
    # example: "networking.ports"
    keyPath ? "", # like "networking.ports"

    # Name of the value of an item. Useful when modules
    # use values in a informal standard way like
    # valueKey = "port" to be able to inherit to
    # `service.<name>.port`
    valueKey ? "value",

    # Returns the processed config with what did go out of
    # the happy path instead of raising hard errors and warnings.
    # This is a workaround for the limitation that tryEval
    # can't recover from errors.
    # Useful for testing.
    dontThrow ? false,
    # <!-- end of user friendliness parameters -->

    # <!-- begin of allocator specific parameters -->
    # first value in the space being allocated
    firstValue ? 0,

    # how to convert one value to a string key that uniquely identifies
    # it to check for conflicts?
    # TODO: better conflict key abstraction
    #   this is actually a really naive and leaky abstraction
    keyFunc ? toString,

    # from one value how to get the next value?
    # the first usage of this function will always be `succFunc firstValue`
    succFunc,

    # validation logic for one value
    validateFunc ? valueType.check or (value: true),
    # <!-- end of allocator specific parameters -->

  }: mkOption {
    inherit
      description
      example
      internal
      relatedPackages
      visible
    ;
    default = {};
    apply = _items: let
      # all items but the disabled ones
      items = removeAttrs _items (filter (item: !_items.${item}.enable) (attrNames _items));

      # keys of enabled items
      itemKeys = attrNames items;

      # check if one item name has a value
      isItemDefined = itemKey: items.${itemKey}.${valueKey} != null;

      # keys of all items that has a value
      definedItems = lib.filter isItemDefined itemKeys;

      # keys of all items that has no value
      undefinedItems = lib.filter (x: !isItemDefined x) itemKeys;

      conflictDict = foldl' (x: y: x // (let
        thisItemValue = items.${y}.${valueKey};
        thisConflictKey = keyFunc thisItemValue;
        conflictKey = x.${thisConflictKey} or null;
        isConflict = conflictKey != null;
        isValid = validateFunc thisItemValue;
        hasProblem = isConflict || !isValid;
      in {
        "${thisConflictKey}" = y; # the item key itself

        #   Utility keys to accumulate all conflicts and invalid
        # values to report later.
        #   Bailing out in this phase is really tricky and can easily
        # cause infinite recursions.
        _conflict = if (x._conflict or null) != null then x._conflict else (if isConflict then {from = conflictKey; to = y; } else null);
        _invalid = (x._invalid or []) ++ (optional (!isValid) y);
      })) {} definedItems;

      getFullKey = key: concatStringsSep "." ((optional (keyPath != "") keyPath) ++ [ key ]);

      isValueConflicts = value: (conflictDict.${keyFunc value} or null) != null;

      # How the suggestion works
      suggestValue = prevValue: if (isValueConflicts prevValue) || (!(validateFunc prevValue)) then suggestValue (succFunc prevValue) else prevValue;

      # It always only look for one value suggestion on demand.
      suggestedValue = suggestValue firstValue;

      # And the suggestion representation can be required in any of
      # these checks
      suggestedValueLiteral = valueLiteral suggestedValue;

      handleCondition = isThrow: condition: message: _passthru:
        let
          handler = if isThrow then lib.throwIfNot else lib.warnIfNot;
          handledValue = handler condition message _passthru;

          dontThrowValue = _passthru // {
            _message = (_passthru._message or []) ++ (optional (!condition) message);
            _conflictDict = conflictDict;
            _steps = mapAttrs (k: v: v items) { inherit handleMissingKeyPath handleMissingValues handleConflicts handleInvalidValues; };
          };
          handledValueDontThrow = if condition then _passthru else dontThrowValue;
        in if dontThrow then handledValueDontThrow else handledValue;

      handleConditionThrow = handleCondition true;
      handleConditionWarn = handleCondition false;

      handleMissingKeyPath = handleConditionWarn (keyPath != "")
        "mkAllocatorModule: keyPath missing. Error messages will be less useful";
      handleMissingValues = handleConditionThrow (length undefinedItems == 0)
        "Key ${getFullKey (head undefinedItems)} is missing a value. Suggestion: set the value to: `${suggestedValueLiteral}`";
      handleConflicts = handleConditionThrow (conflictDict._conflict == null)
        "Key ${getFullKey conflictDict._conflict.from} and ${getFullKey conflictDict._conflict.to} have the same values. Suggestion: change the value of one of them to: `${suggestedValueLiteral}`";
      handleInvalidValues = handleConditionThrow (length conflictDict._invalid == 0)
        "The following keys have invalid values: ${concatStringsSep ", " (map (getFullKey) conflictDict._invalid)}. Suggestion: change the value of the first key to: `${suggestedValueLiteral}`";

    in lib.pipe items [
      handleMissingKeyPath
      handleMissingValues
      handleConflicts
      handleInvalidValues
    ];

    type = lib.types.attrsOf (lib.types.submodule ({ name, config, options, ... }: {
      options = {
        enable = mkEnableOption (if isString enableDescription then enableDescription else enableDescription name);

        "${valueKey}" = mkOption {
          default = null;

          description = mkEnableOption (if isString valueDescription then valueDescription else valueDescription name);
          type = lib.types.nullOr valueType;
        };
      };
    }));
  };


  /* This option accepts anything, but it does not produce any result.

     This is useful for sharing a module across different module sets
     without having to implement similar features as long as the
     values of the options are not accessed. */
  mkSinkUndeclaredOptions = attrs: mkOption ({
    internal = true;
    visible = false;
    default = false;
    description = "Sink for option definitions.";
    type = mkOptionType {
      name = "sink";
      check = x: true;
      merge = loc: defs: false;
    };
    apply = x: throw "Option value is not readable because the option is not declared.";
  } // attrs);

  mergeDefaultOption = loc: defs:
    let list = getValues defs; in
    if length list == 1 then head list
    else if all isFunction list then x: mergeDefaultOption loc (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then foldl' lib.mergeAttrs {} list
    else if all isBool list then foldl' lib.or false list
    else if all isString list then lib.concatStrings list
    else if all isInt list && all (x: x == head list) list then head list
    else throw "Cannot merge definitions of `${showOption loc}'. Definition values:${showDefs defs}";

  mergeOneOption = mergeUniqueOption { message = ""; };

  mergeUniqueOption = { message }: loc: defs:
    if length defs == 1
    then (head defs).value
    else assert length defs > 1;
      throw "The option `${showOption loc}' is defined multiple times while it's expected to be unique.\n${message}\nDefinition values:${showDefs defs}\n${prioritySuggestion}";

  /* "Merge" option definitions by checking that they all have the same value. */
  mergeEqualOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    # Return early if we only have one element
    # This also makes it work for functions, because the foldl' below would try
    # to compare the first element with itself, which is false for functions
    else if length defs == 1 then (head defs).value
    else (foldl' (first: def:
      if def.value != first.value then
        throw "The option `${showOption loc}' has conflicting definition values:${showDefs [ first def ]}\n${prioritySuggestion}"
      else
        first) (head defs) (tail defs)).value;

  /* Extracts values of all "value" keys of the given list.

     Type: getValues :: [ { value :: a; } ] -> [a]

     Example:
       getValues [ { value = 1; } { value = 2; } ] // => [ 1 2 ]
       getValues [ ]                               // => [ ]
  */
  getValues = map (x: x.value);

  /* Extracts values of all "file" keys of the given list

     Type: getFiles :: [ { file :: a; } ] -> [a]

     Example:
       getFiles [ { file = "file1"; } { file = "file2"; } ] // => [ "file1" "file2" ]
       getFiles [ ]                                         // => [ ]
  */
  getFiles = map (x: x.file);

  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = _: options:
    concatMap (opt:
      let
        name = showOption opt.loc;
        docOption = {
          loc = opt.loc;
          inherit name;
          description = opt.description or null;
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible =
            if (opt?visible && opt.visible == "shallow")
            then true
            else opt.visible or true;
          readOnly = opt.readOnly or false;
          type = opt.type.description or "unspecified";
        }
        // optionalAttrs (opt ? example) {
          example =
            builtins.addErrorContext "while evaluating the example of option `${name}`" (
              renderOptionValue opt.example
            );
        }
        // optionalAttrs (opt ? defaultText || opt ? default) {
          default =
            builtins.addErrorContext "while evaluating the ${if opt?defaultText then "defaultText" else "default value"} of option `${name}`" (
              renderOptionValue (opt.defaultText or opt.default)
            );
        }
        // optionalAttrs (opt ? relatedPackages && opt.relatedPackages != null) { inherit (opt) relatedPackages; };

        subOptions =
          let ss = opt.type.getSubOptions opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc ss else [];
        subOptionsVisible = docOption.visible && opt.visible or null != "shallow";
      in
        # To find infinite recursion in NixOS option docs:
        # builtins.trace opt.loc
        [ docOption ] ++ optionals subOptionsVisible subOptions) (collect isOption options);


  /* This function recursively removes all derivation attributes from
     `x` except for the `name` attribute.

     This is to make the generation of `options.xml` much more
     efficient: the XML representation of derivations is very large
     (on the order of megabytes) and is not actually used by the
     manual generator.

     This function was made obsolete by renderOptionValue and is kept for
     compatibility with out-of-tree code.
  */
  scrubOptionValue = x:
    if isDerivation x then
      { type = "derivation"; drvPath = x.name; outPath = x.name; name = x.name; }
    else if isList x then map scrubOptionValue x
    else if isAttrs x then mapAttrs (n: v: scrubOptionValue v) (removeAttrs x ["_args"])
    else x;


  /* Ensures that the given option value (default or example) is a `_type`d string
     by rendering Nix values to `literalExpression`s.
  */
  renderOptionValue = v:
    if v ? _type && v ? text then v
    else literalExpression (lib.generators.toPretty {
      multiline = true;
      allowPrettyValues = true;
    } v);


  /* For use in the `defaultText` and `example` option attributes. Causes the
     given string to be rendered verbatim in the documentation as Nix code. This
     is necessary for complex values, e.g. functions, or values that depend on
     other values or packages.
  */
  literalExpression = text:
    if ! isString text then throw "literalExpression expects a string."
    else { _type = "literalExpression"; inherit text; };

  literalExample = lib.warn "literalExample is deprecated, use literalExpression instead, or use literalMD for a non-Nix description." literalExpression;

  /* Transition marker for documentation that's already migrated to markdown
     syntax. This is a no-op and no longer needed.
  */
  mdDoc = lib.id;

  /* For use in the `defaultText` and `example` option attributes. Causes the
     given MD text to be inserted verbatim in the documentation, for when
     a `literalExpression` would be too hard to read.
  */
  literalMD = text:
    if ! isString text then throw "literalMD expects a string."
    else { _type = "literalMD"; inherit text; };

  # Helper functions.

  /* Convert an option, described as a list of the option parts to a
     human-readable version.

     Example:
       (showOption ["foo" "bar" "baz"]) == "foo.bar.baz"
       (showOption ["foo" "bar.baz" "tux"]) == "foo.\"bar.baz\".tux"
       (showOption ["windowManager" "2bwm" "enable"]) == "windowManager.\"2bwm\".enable"

     Placeholders will not be quoted as they are not actual values:
       (showOption ["foo" "*" "bar"]) == "foo.*.bar"
       (showOption ["foo" "<name>" "bar"]) == "foo.<name>.bar"
  */
  showOption = parts: let
    escapeOptionPart = part:
      let
        # We assume that these are "special values" and not real configuration data.
        # If it is real configuration data, it is rendered incorrectly.
        specialIdentifiers = [
          "<name>"          # attrsOf (submodule {})
          "*"               # listOf (submodule {})
          "<function body>" # functionTo
        ];
      in if builtins.elem part specialIdentifiers
         then part
         else lib.strings.escapeNixIdentifier part;
    in (concatStringsSep ".") (map escapeOptionPart parts);
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);

  showDefs = defs: concatMapStrings (def:
    let
      # Pretty print the value for display, if successful
      prettyEval = builtins.tryEval
        (lib.generators.toPretty { }
          (lib.generators.withRecursion { depthLimit = 10; throwOnDepthLimit = false; } def.value));
      # Split it into its lines
      lines = filter (v: ! isList v) (builtins.split "\n" prettyEval.value);
      # Only display the first 5 lines, and indent them for better visibility
      value = concatStringsSep "\n    " (take 5 lines ++ optional (length lines > 5) "...");
      result =
        # Don't print any value if evaluating the value strictly fails
        if ! prettyEval.success then ""
        # Put it on a new line if it consists of multiple
        else if length lines > 1 then ":\n    " + value
        else ": " + value;
    in "\n- In `${def.file}'${result}"
  ) defs;

  showOptionWithDefLocs = opt: ''
      ${showOption opt.loc}, with values defined in:
      ${concatMapStringsSep "\n" (defFile: "  - ${defFile}") opt.files}
    '';

  unknownModule = "<unknown-file>";

}
