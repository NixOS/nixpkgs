/* Nixpkgs/NixOS option handling. */
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
     Because of this, you need to pass nixpkgs itself (usually `pkgs` in a module;
     alternatively to nixpkgs itself, another package set) as the first argument.

     If you pass another package set you should set the `pkgsText` option.
     This option is used to display the expression for the package set. It is `"pkgs"` by default.
     If your expression is complex you should parenthesize it, as the `pkgsText` argument
     is usually immediately followed by an attribute lookup (`.`).

     The second argument may be either a string or a list of strings.
     It provides the display name of the package in the description of the generated option
     (using only the last element if the passed value is a list)
     and serves as the fallback value for the `default` argument.

     To include extra information in the description, pass `extraDescription` to
     append arbitrary text to the generated description.

     You can also pass an `example` value, either a literal string or an attribute path.

     The `default` argument can be omitted if the provided name is
     an attribute of pkgs (if `name` is a string) or a valid attribute path in pkgs (if `name` is a list).
     You can also set `default` to just a string in which case it is interpreted as an attribute name
     (a singleton attribute path, if you will).

     If you wish to explicitly provide no default, pass `null` as `default`.

     If you want users to be able to set no package, pass `nullable = true`.
     In this mode a `default = null` will not be interpreted as no default and is interpreted literally.

     Type: mkPackageOption :: pkgs -> (string|[string]) -> { nullable? :: bool, default? :: string|[string], example? :: null|string|[string], extraDescription? :: string, pkgsText? :: string } -> option

     Example:
       mkPackageOption pkgs "hello" { }
       => { ...; default = pkgs.hello; defaultText = literalExpression "pkgs.hello"; description = "The hello package to use."; type = package; }

     Example:
       mkPackageOption pkgs "GHC" {
         default = [ "ghc" ];
         example = "pkgs.haskell.packages.ghc92.ghc.withPackages (hkgs: [ hkgs.primes ])";
       }
       => { ...; default = pkgs.ghc; defaultText = literalExpression "pkgs.ghc"; description = "The GHC package to use."; example = literalExpression "pkgs.haskell.packages.ghc92.ghc.withPackages (hkgs: [ hkgs.primes ])"; type = package; }

     Example:
       mkPackageOption pkgs [ "python3Packages" "pytorch" ] {
         extraDescription = "This is an example and doesn't actually do anything.";
       }
       => { ...; default = pkgs.python3Packages.pytorch; defaultText = literalExpression "pkgs.python3Packages.pytorch"; description = "The pytorch package to use. This is an example and doesn't actually do anything."; type = package; }

     Example:
       mkPackageOption pkgs "nushell" {
         nullable = true;
       }
       => { ...; default = pkgs.nushell; defaultText = literalExpression "pkgs.nushell"; description = "The nushell package to use."; type = nullOr package; }

     Example:
       mkPackageOption pkgs "coreutils" {
         default = null;
       }
       => { ...; description = "The coreutils package to use."; type = package; }

     Example:
       mkPackageOption pkgs "dbus" {
         nullable = true;
         default = null;
       }
       => { ...; default = null; description = "The dbus package to use."; type = nullOr package; }

     Example:
       mkPackageOption pkgs.javaPackages "OpenJFX" {
         default = "openjfx20";
         pkgsText = "pkgs.javaPackages";
       }
       => { ...; default = pkgs.javaPackages.openjfx20; defaultText = literalExpression "pkgs.javaPackages.openjfx20"; description = "The OpenJFX package to use."; type = package; }
  */
  mkPackageOption =
    # Package set (an instantiation of nixpkgs such as pkgs in modules or another package set)
    pkgs:
      # Name for the package, shown in option description
      name:
      {
        # Whether the package can be null, for example to disable installing a package altogether (defaults to false)
        nullable ? false,
        # The attribute path where the default package is located (may be omitted, in which case it is copied from `name`)
        default ? name,
        # A string or an attribute path to use as an example (may be omitted)
        example ? null,
        # Additional text to include in the option description (may be omitted)
        extraDescription ? "",
        # Representation of the package set passed as pkgs (defaults to `"pkgs"`)
        pkgsText ? "pkgs"
      }:
      let
        name' = if isList name then last name else name;
        default' = if isList default then default else [ default ];
        defaultText = concatStringsSep "." default';
        defaultValue = attrByPath default'
          (throw "${defaultText} cannot be found in ${pkgsText}") pkgs;
        defaults = if default != null then {
          default = defaultValue;
          defaultText = literalExpression ("${pkgsText}." + defaultText);
        } else optionalAttrs nullable {
          default = null;
        };
      in mkOption (defaults // {
        description = "The ${name'} package to use."
          + (if extraDescription == "" then "" else " ") + extraDescription;
        type = with lib.types; (if nullable then nullOr else lib.id) package;
      } // optionalAttrs (example != null) {
        example = literalExpression
          (if isList example then "${pkgsText}." + concatStringsSep "." example else example);
      });

  /* Deprecated alias of mkPackageOption, to be removed in 25.05.
     Previously used to create options with markdown documentation, which is no longer required.
  */
  mkPackageOptionMD = lib.warn "mkPackageOptionMD is deprecated and will be removed in 25.05; please use mkPackageOption." mkPackageOption;

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

  /*
    Require a single definition.

    WARNING: Does not perform nested checks, as this does not run the merge function!
    */
  mergeOneOption = mergeUniqueOption { message = ""; };

  /*
    Require a single definition.

    NOTE: When the type is not checked completely by check, pass a merge function for further checking (of sub-attributes, etc).
   */
  mergeUniqueOption = args@{
      message,
      # WARNING: the default merge function assumes that the definition is a valid (option) value. You MUST pass a merge function if the return value needs to be
      #   - type checked beyond what .check does (which should be very litte; only on the value head; not attribute values, etc)
      #   - if you want attribute values to be checked, or list items
      #   - if you want coercedTo-like behavior to work
      merge ? loc: defs: (head defs).value }:
    loc: defs:
      if length defs == 1
      then merge loc defs
      else
        assert length defs > 1;
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

  literalExample = lib.warn "lib.literalExample is deprecated, use lib.literalExpression instead, or use lib.literalMD for a non-Nix description." literalExpression;

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
