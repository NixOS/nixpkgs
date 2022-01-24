# Nixpkgs/NixOS option handling.
{ lib }:

let
  inherit (lib)
    all
    collect
    concatLists
    concatMap
    elemAt
    filter
    foldl'
    head
    tail
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
    take
    ;
  inherit (lib.attrsets)
    attrByPath
    optionalAttrs
    ;
  inherit (lib.strings)
    concatMapStrings
    concatStringsSep
    ;
  inherit (lib.types)
    mkOptionType
    ;
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
    # Deprecated, used by types.optionSet.
    options ? null
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

     Type: mkPackageOption :: pkgs -> string -> { default :: [string], example :: null | string | [string] } -> option

     The package is specified as a list of strings representing its attribute path in nixpkgs.

     Because of this, you need to pass nixpkgs itself as the first argument.

     The second argument is the name of the option, used in the description "The <name> package to use.".

     You can also pass an example value, either a literal string or a package's attribute path.

     You can omit the default path if the name of the option is also attribute path in nixpkgs.

     Example:
       mkPackageOption pkgs "hello" { }
       => { _type = "option"; default = «derivation /nix/store/3r2vg51hlxj3cx5vscp0vkv60bqxkaq0-hello-2.10.drv»; defaultText = { ... }; description = "The hello package to use."; type = { ... }; }

     Example:
       mkPackageOption pkgs "GHC" {
         default = [ "ghc" ];
         example = "pkgs.haskell.package.ghc921.ghc.withPackages (hkgs: [ hkgs.primes ])";
       }
       => { _type = "option"; default = «derivation /nix/store/jxx55cxsjrf8kyh3fp2ya17q99w7541r-ghc-8.10.7.drv»; defaultText = { ... }; description = "The GHC package to use."; example = { ... }; type = { ... }; }
  */
  mkPackageOption =
    # Package set (a specific version of nixpkgs)
    pkgs:
      # Name for the package, shown in option description
      name:
      { default ? [ name ], example ? null }:
      let default' = if !isList default then [ default ] else default;
      in mkOption {
        type = lib.types.package;
        description = "The ${name} package to use.";
        default = attrByPath default'
          (throw "${concatStringsSep "." default'} cannot be found in pkgs") pkgs;
        defaultText = literalExpression ("pkgs." + concatStringsSep "." default');
        ${if example != null then "example" else null} = literalExpression
          (if isList example then "pkgs." + concatStringsSep "." example else example);
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

  mergeOneOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    else if length defs != 1 then
      throw "The unique option `${showOption loc}' is defined multiple times. Definition values:${showDefs defs}"
    else (head defs).value;

  /* "Merge" option definitions by checking that they all have the same value. */
  mergeEqualOption = loc: defs:
    if defs == [] then abort "This case should never happen."
    # Return early if we only have one element
    # This also makes it work for functions, because the foldl' below would try
    # to compare the first element with itself, which is false for functions
    else if length defs == 1 then (head defs).value
    else (foldl' (first: def:
      if def.value != first.value then
        throw "The option `${showOption loc}' has conflicting definition values:${showDefs [ first def ]}"
      else
        first) (head defs) (tail defs)).value;

  /* Extracts values of all "value" keys of the given list.

     Type: getValues :: [ { value :: a } ] -> [a]

     Example:
       getValues [ { value = 1; } { value = 2; } ] // => [ 1 2 ]
       getValues [ ]                               // => [ ]
  */
  getValues = map (x: x.value);

  /* Extracts values of all "file" keys of the given list

     Type: getFiles :: [ { file :: a } ] -> [a]

     Example:
       getFiles [ { file = "file1"; } { file = "file2"; } ] // => [ "file1" "file2" ]
       getFiles [ ]                                         // => [ ]
  */
  getFiles = map (x: x.file);

  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = prefix: options:
    concatMap (opt:
      let
        docOption = rec {
          loc = opt.loc;
          name = showOption opt.loc;
          description = opt.description or null;
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible =
            if (opt?visible && opt.visible == "shallow")
            then true
            else opt.visible or true;
          readOnly = opt.readOnly or false;
          type = opt.type.description or null;
        }
        // optionalAttrs (opt ? example) { example = scrubOptionValue opt.example; }
        // optionalAttrs (opt ? default) { default = scrubOptionValue opt.default; }
        // optionalAttrs (opt ? defaultText) { default = opt.defaultText; }
        // optionalAttrs (opt ? relatedPackages && opt.relatedPackages != null) { inherit (opt) relatedPackages; };

        subOptions =
          let ss = opt.type.getSubOptions opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc ss else [];
        subOptionsVisible = docOption.visible && opt.visible or null != "shallow";
      in
        [ docOption ] ++ optionals subOptionsVisible subOptions) (collect isOption options);


  /* This function recursively removes all derivation attributes from
     `x` except for the `name` attribute.

     This is to make the generation of `options.xml` much more
     efficient: the XML representation of derivations is very large
     (on the order of megabytes) and is not actually used by the
     manual generator.
  */
  scrubOptionValue = x:
    if isDerivation x then
      { type = "derivation"; drvPath = x.name; outPath = x.name; name = x.name; }
    else if isList x then map scrubOptionValue x
    else if isAttrs x then mapAttrs (n: v: scrubOptionValue v) (removeAttrs x ["_args"])
    else x;


  /* For use in the `defaultText` and `example` option attributes. Causes the
     given string to be rendered verbatim in the documentation as Nix code. This
     is necessary for complex values, e.g. functions, or values that depend on
     other values or packages.
  */
  literalExpression = text:
    if ! isString text then throw "literalExpression expects a string."
    else { _type = "literalExpression"; inherit text; };

  literalExample = lib.warn "literalExample is deprecated, use literalExpression instead, or use literalDocBook for a non-Nix description." literalExpression;


  /* For use in the `defaultText` and `example` option attributes. Causes the
     given DocBook text to be inserted verbatim in the documentation, for when
     a `literalExpression` would be too hard to read.
  */
  literalDocBook = text:
    if ! isString text then throw "literalDocBook expects a string."
    else { _type = "literalDocBook"; inherit text; };

  # Helper functions.

  /* Convert an option, described as a list of the option parts in to a
     safe, human readable version.

     Example:
       (showOption ["foo" "bar" "baz"]) == "foo.bar.baz"
       (showOption ["foo" "bar.baz" "tux"]) == "foo.bar.baz.tux"

     Placeholders will not be quoted as they are not actual values:
       (showOption ["foo" "*" "bar"]) == "foo.*.bar"
       (showOption ["foo" "<name>" "bar"]) == "foo.<name>.bar"

     Unlike attributes, options can also start with numbers:
       (showOption ["windowManager" "2bwm" "enable"]) == "windowManager.2bwm.enable"
  */
  showOption = parts: let
    escapeOptionPart = part:
      let
        escaped = lib.strings.escapeNixString part;
      in if escaped == "\"${part}\""
         then part
         else escaped;
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

  unknownModule = "<unknown-file>";

}
