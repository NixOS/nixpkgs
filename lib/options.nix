/**
  Module System option handling.
*/
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
    showAttrPath
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
    toList
    ;
  prioritySuggestion = ''
    Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  '';
in
rec {

  /**
    Returns true when the given argument `a` is an option

    # Inputs

    `a`
    : Any value to check whether it is an option

    # Examples
    :::{.example}
    ## `lib.options.isOption` usage example

    ```nix
    isOption 1             // => false
    isOption (mkOption {}) // => true
    ```

    :::

    # Type

    ```
    isOption :: a -> Bool
    ```
  */
  isOption = lib.isType "option";

  /**
    Creates an Option attribute set. mkOption accepts an attribute set with the following keys:

    # Inputs

    Structured attribute set
    : Attribute set containing none or some of the following attributes.

      `default`
      : Optional default value used when no definition is given in the configuration.

      `defaultText`
      : Substitute for documenting the `default`, if evaluating the default value during documentation rendering is not possible.
      : Can be any nix value that evaluates.
      : Usage with `lib.literalMD` or `lib.literalExpression` is supported

      `example`
      : Optional example value used in the manual.
      : Can be any nix value that evaluates.
      : Usage with `lib.literalMD` or `lib.literalExpression` is supported

      `description`
      : Optional string describing the option. This is required if option documentation is generated.

      `relatedPackages`
      : Optional related packages used in the manual (see `genRelatedPackages` in `../nixos/lib/make-options-doc/default.nix`).

      `type`
      : Optional option type, providing type-checking and value merging.

      `apply`
      : Optional function that converts the option value to something else.

      `internal`
      : Optional boolean indicating whether the option is for NixOS developers only.

      `visible`
      : Optional, whether the option and/or sub-options show up in the manual.
        Use false to hide the option and any sub-options from submodules.
        Use "shallow" to hide only sub-options.
        Use "transparent" to hide this option, but not its sub-options.
        Default: true.

      `readOnly`
      : Optional boolean indicating whether the option can be set only once.

      `...` (any other attribute)
      : Any other attribute is passed through to the resulting option attribute set.

    # Examples
    :::{.example}
    ## `lib.options.mkOption` usage example

    ```nix
    mkOption { }  // => { _type = "option"; }
    mkOption { default = "foo"; } // => { _type = "option"; default = "foo"; }
    ```

    :::
  */
  mkOption =
    {
      default ? null,
      defaultText ? null,
      example ? null,
      description ? null,
      relatedPackages ? null,
      type ? null,
      apply ? null,
      internal ? null,
      visible ? null,
      readOnly ? null,
    }@attrs:
    attrs // { _type = "option"; };

  /**
    Creates an option declaration with a default value of ´false´, and can be defined to ´true´.

    # Inputs

    `name`

    : Name for the created option

    # Examples
    :::{.example}
    ## `lib.options.mkEnableOption` usage example

    ```nix
    # module
    let
      eval = lib.evalModules {
        modules = [
          {
            options.foo.enable = mkEnableOption "foo";

            config.foo.enable = true;
          }
        ];
      };
    in
    eval.config
    => { foo.enable = true; }
    ```

    :::
  */
  mkEnableOption =
    name:
    mkOption {
      default = false;
      example = true;
      description = "Whether to enable ${name}.";
      type = lib.types.bool;
    };

  /**
    Creates an Option attribute set for an option that specifies the
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

    # Inputs

    `pkgs`

    : Package set (an instantiation of nixpkgs such as pkgs in modules or another package set)

    `name`

    : Name for the package, shown in option description

    Structured function argument
    : Attribute set containing the following attributes.

      `nullable`
      : Optional whether the package can be null, for example to disable installing a package altogether. Default: `false`

      `default`
      : Optional attribute path where the default package is located. Default: `name`
        If omitted will be copied from `name`

      `example`
      : Optional string or an attribute path to use as an example. Default: `null`

      `extraDescription`
      : Optional additional text to include in the option description. Default: `""`

      `pkgsText`
      : Optional representation of the package set passed as pkgs. Default: `"pkgs"`

    # Type

    ```
    mkPackageOption :: pkgs -> (string|[string]) -> { nullable? :: bool, default? :: string|[string], example? :: null|string|[string], extraDescription? :: string, pkgsText? :: string } -> option
    ```

    # Examples
    :::{.example}
    ## `lib.options.mkPackageOption` usage example

    ```nix
    mkPackageOption pkgs "hello" { }
    => { ...; default = pkgs.hello; defaultText = literalExpression "pkgs.hello"; description = "The hello package to use."; type = package; }

    mkPackageOption pkgs "GHC" {
      default = [ "ghc" ];
      example = "pkgs.haskellPackages.ghc.withPackages (hkgs: [ hkgs.primes ])";
    }
    => { ...; default = pkgs.ghc; defaultText = literalExpression "pkgs.ghc"; description = "The GHC package to use."; example = literalExpression "pkgs.haskellPackages.ghc.withPackages (hkgs: [ hkgs.primes ])"; type = package; }

    mkPackageOption pkgs [ "python3Packages" "pytorch" ] {
      extraDescription = "This is an example and doesn't actually do anything.";
    }
    => { ...; default = pkgs.python3Packages.pytorch; defaultText = literalExpression "pkgs.python3Packages.pytorch"; description = "The pytorch package to use. This is an example and doesn't actually do anything."; type = package; }

    mkPackageOption pkgs "nushell" {
      nullable = true;
    }
    => { ...; default = pkgs.nushell; defaultText = literalExpression "pkgs.nushell"; description = "The nushell package to use."; type = nullOr package; }

    mkPackageOption pkgs "coreutils" {
      default = null;
    }
    => { ...; description = "The coreutils package to use."; type = package; }

    mkPackageOption pkgs "dbus" {
      nullable = true;
      default = null;
    }
    => { ...; default = null; description = "The dbus package to use."; type = nullOr package; }

    mkPackageOption pkgs.javaPackages "OpenJFX" {
      default = "openjfx20";
      pkgsText = "pkgs.javaPackages";
    }
    => { ...; default = pkgs.javaPackages.openjfx20; defaultText = literalExpression "pkgs.javaPackages.openjfx20"; description = "The OpenJFX package to use."; type = package; }
    ```

    :::
  */
  mkPackageOption =
    pkgs: name:
    {
      nullable ? false,
      default ? name,
      example ? null,
      extraDescription ? "",
      pkgsText ? "pkgs",
    }:
    let
      name' = if isList name then last name else name;
      default' = toList default;
      defaultText = showAttrPath default';
      defaultValue = attrByPath default' (throw "${defaultText} cannot be found in ${pkgsText}") pkgs;
      defaults =
        if default != null then
          {
            default = defaultValue;
            defaultText = literalExpression "${pkgsText}.${defaultText}";
          }
        else
          optionalAttrs nullable {
            default = null;
          };
    in
    mkOption (
      defaults
      // {
        description =
          "The ${name'} package to use." + (if extraDescription == "" then "" else " ") + extraDescription;
        type = with lib.types; (if nullable then nullOr else lib.id) package;
      }
      // optionalAttrs (example != null) {
        example = literalExpression (
          if isList example then "${pkgsText}.${showAttrPath example}" else example
        );
      }
    );

  /**
    This option accepts arbitrary definitions, but it does not produce an option value.

    This is useful for sharing a module across different module sets
    without having to implement similar features as long as the
    values of the options are not accessed.

    # Inputs

    `attrs`

    : Attribute set whose attributes override the argument to `mkOption`.
  */
  mkSinkUndeclaredOptions =
    attrs:
    mkOption (
      {
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
      }
      // attrs
    );

  /**
    A merge function that merges multiple definitions of an option into a single value

    :::{.caution}
    This function is used as the default merge operation in `lib.types.mkOptionType`. In most cases, explicit usage of this function is unnecessary.
    :::

    # Inputs

    `loc`
    : location of the option in the configuration as a list of strings.

      e.g. `["boot" "loader "grub" "enable"]`

    `defs`
    : list of definition values and locations.

      e.g. `[ { file = "/foo.nix"; value = 1; } { file = "/bar.nix"; value = 2 } ]`

    # Example
    :::{.example}
    ## `lib.options.mergeDefaultOption` usage example

    ```nix
    myType = mkOptionType {
      name = "myType";
      merge = mergeDefaultOption; # <- This line is redundant. It is the default already.
    };
    ```

    :::

    # Merge behavior

    Merging requires all definition values to have the same type.

    - If all definitions are booleans, the result of a `foldl'` with the `or` operation is returned.
    - If all definitions are strings, they are concatenated. (`lib.concatStrings`)
    - If all definitions are integers and all are equal, the first one is returned.
    - If all definitions are lists, they are concatenated. (`++`)
    - If all definitions are attribute sets, they are merged. (`lib.mergeAttrs`)
    - If all definitions are functions, the first function is applied to the result of the second function. (`f -> x: f x`)
    - Otherwise, an error is thrown.
  */
  mergeDefaultOption =
    loc: defs:
    let
      list = getValues defs;
    in
    if length list == 1 then
      head list
    else if all isFunction list then
      x: mergeDefaultOption loc (map (f: f x) list)
    else if all isList list then
      concatLists list
    else if all isAttrs list then
      foldl' lib.mergeAttrs { } list
    else if all isBool list then
      foldl' lib.or false list
    else if all isString list then
      lib.concatStrings list
    else if all isInt list && all (x: x == head list) list then
      head list
    else
      throw "Cannot merge definitions of `${showOption loc}'. Definition values:${showDefs defs}";

  /**
    Require a single definition.

    WARNING: Does not perform nested checks, as this does not run the merge function!
  */
  mergeOneOption = mergeUniqueOption { message = ""; };

  /**
    Require a single definition.

    NOTE: When the type is not checked completely by check, pass a merge function for further checking (of sub-attributes, etc).

    # Inputs

    `loc`

    : 2\. Function argument

    `defs`

    : 3\. Function argument
  */
  mergeUniqueOption =
    args@{
      message,
      # WARNING: the default merge function assumes that the definition is a valid (option) value. You MUST pass a merge function if the return value needs to be
      #   - type checked beyond what .check does (which should be very little; only on the value head; not attribute values, etc)
      #   - if you want attribute values to be checked, or list items
      #   - if you want coercedTo-like behavior to work
      merge ? loc: defs: (head defs).value,
    }:
    loc: defs:
    if length defs == 1 then
      merge loc defs
    else
      assert length defs > 1;
      throw "The option `${showOption loc}' is defined multiple times while it's expected to be unique.\n${message}\nDefinition values:${showDefs defs}\n${prioritySuggestion}";

  /**
    "Merge" option definitions by checking that they all have the same value.

    # Inputs

    `loc`

    : 1\. Function argument

    `defs`

    : 2\. Function argument
  */
  mergeEqualOption =
    loc: defs:
    if defs == [ ] then
      abort "This case should never happen."
    # Returns early if we only have one element
    # This also makes it work for functions, because the foldl' below would try
    # to compare the first element with itself, which is false for functions
    else if length defs == 1 then
      (head defs).value
    else
      (foldl' (
        first: def:
        if def.value != first.value then
          throw "The option `${showOption loc}' has conflicting definition values:${
            showDefs [
              first
              def
            ]
          }\n${prioritySuggestion}"
        else
          first
      ) (head defs) (tail defs)).value;

  /**
    Extracts values of all "value" keys of the given list.

    # Type

    ```
    getValues :: [ { value :: a; } ] -> [a]
    ```

    # Examples
    :::{.example}
    ## `getValues` usage example

    ```nix
    getValues [ { value = 1; } { value = 2; } ] // => [ 1 2 ]
    getValues [ ]                               // => [ ]
    ```

    :::
  */
  getValues = map (x: x.value);

  /**
    Extracts values of all "file" keys of the given list

    # Type

    ```
    getFiles :: [ { file :: a; } ] -> [a]
    ```

    # Examples
    :::{.example}
    ## `getFiles` usage example

    ```nix
    getFiles [ { file = "file1"; } { file = "file2"; } ] // => [ "file1" "file2" ]
    getFiles [ ]                                         // => [ ]
    ```

    :::
  */
  getFiles = map (x: x.file);

  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [ ];

  optionAttrSetToDocList' =
    _: options:
    concatMap (
      opt:
      let
        name = showOption opt.loc;
        visible = opt.visible or true;
        docOption = {
          loc = opt.loc;
          inherit name;
          description = opt.description or null;
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible = if isBool visible then visible else visible == "shallow";
          readOnly = opt.readOnly or false;
          type = opt.type.description or "unspecified";
        }
        // optionalAttrs (opt ? example) {
          example = builtins.addErrorContext "while evaluating the example of option `${name}`" (
            renderOptionValue opt.example
          );
        }
        // optionalAttrs (opt ? defaultText || opt ? default) {
          default = builtins.addErrorContext "while evaluating the ${
            if opt ? defaultText then "defaultText" else "default value"
          } of option `${name}`" (renderOptionValue (opt.defaultText or opt.default));
        }
        // optionalAttrs (opt ? relatedPackages && opt.relatedPackages != null) {
          inherit (opt) relatedPackages;
        };

        subOptions =
          let
            ss = opt.type.getSubOptions opt.loc;
          in
          if ss != { } then optionAttrSetToDocList' opt.loc ss else [ ];
        subOptionsVisible = if isBool visible then visible else visible == "transparent";
      in
      # To find infinite recursion in NixOS option docs:
      # builtins.trace opt.loc
      [ docOption ] ++ optionals subOptionsVisible subOptions
    ) (collect isOption options);

  /**
    This function recursively removes all derivation attributes from
    `x` except for the `name` attribute.

    This is to make the generation of `options.xml` much more
    efficient: the XML representation of derivations is very large
    (on the order of megabytes) and is not actually used by the
    manual generator.

    This function was made obsolete by renderOptionValue and is kept for
    compatibility with out-of-tree code.

    # Inputs

    `x`

    : 1\. Function argument
  */
  scrubOptionValue =
    x:
    if isDerivation x then
      {
        type = "derivation";
        drvPath = x.name;
        outPath = x.name;
        name = x.name;
      }
    else if isList x then
      map scrubOptionValue x
    else if isAttrs x then
      mapAttrs (n: v: scrubOptionValue v) (removeAttrs x [ "_args" ])
    else
      x;

  /**
    Ensures that the given option value (default or example) is a `_type`d string
    by rendering Nix values to `literalExpression`s.

    # Inputs

    `v`

    : 1\. Function argument
  */
  renderOptionValue =
    v:
    if v ? _type && v ? text then
      v
    else
      literalExpression (
        lib.generators.toPretty {
          multiline = true;
          allowPrettyValues = true;
        } v
      );

  /**
    For use in the `defaultText` and `example` option attributes. Causes the
    given string to be rendered verbatim in the documentation as Nix code. This
    is necessary for complex values, e.g. functions, or values that depend on
    other values or packages.

    # Inputs

    `text`

    : 1\. Function argument
  */
  literalExpression =
    text:
    if !isString text then
      throw "literalExpression expects a string."
    else
      {
        _type = "literalExpression";
        inherit text;
      };

  /**
    For use in the `defaultText` and `example` option attributes. Causes the
    given MD text to be inserted verbatim in the documentation, for when
    a `literalExpression` would be too hard to read.

    # Inputs

    `text`

    : 1\. Function argument
  */
  literalMD =
    text:
    if !isString text then
      throw "literalMD expects a string."
    else
      {
        _type = "literalMD";
        inherit text;
      };

  # Helper functions.

  /**
    Convert an option, described as a list of the option parts to a
    human-readable version.

    # Inputs

    `parts`

    : 1\. Function argument

    # Examples
    :::{.example}
    ## `showOption` usage example

    ```nix
    (showOption ["foo" "bar" "baz"]) == "foo.bar.baz"
      (showOption ["foo" "bar.baz" "tux"]) == "foo.\"bar.baz\".tux"
      (showOption ["windowManager" "2bwm" "enable"]) == "windowManager.\"2bwm\".enable"

    Placeholders will not be quoted as they are not actual values:
      (showOption ["foo" "*" "bar"]) == "foo.*.bar"
      (showOption ["foo" "<name>" "bar"]) == "foo.<name>.bar"
      (showOption ["foo" "<myPlaceholder>" "bar"]) == "foo.<myPlaceholder>.bar"
    ```

    :::
  */
  showOption =
    parts:
    let
      # If the part is a named placeholder of the form "<...>" don't escape it.
      # It may cause misleading escaping if somebody uses literally "<...>" in their option names.
      # This is the trade-off to allow for placeholders in option names.
      isNamedPlaceholder = builtins.match "<(.*)>";
      escapeOptionPart =
        part:
        if part == "*" || isNamedPlaceholder part != null then
          part
        else
          lib.strings.escapeNixIdentifier part;
    in
    (concatStringsSep ".") (map escapeOptionPart parts);
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);

  showDefs =
    defs:
    concatMapStrings (
      def:
      let
        # Pretty print the value for display, if successful
        prettyEval = builtins.tryEval (
          lib.generators.toPretty { } (
            lib.generators.withRecursion {
              depthLimit = 10;
              throwOnDepthLimit = false;
            } def.value
          )
        );
        # Split it into its lines
        lines = filter (v: !isList v) (builtins.split "\n" prettyEval.value);
        # Only display the first 5 lines, and indent them for better visibility
        value = concatStringsSep "\n    " (take 5 lines ++ optional (length lines > 5) "...");
        result =
          # Don't print any value if evaluating the value strictly fails
          if !prettyEval.success then
            ""
          # Put it on a new line if it consists of multiple
          else if length lines > 1 then
            ":\n    " + value
          else
            ": " + value;
      in
      "\n- In `${def.file}'${result}"
    ) defs;

  /**
    Pretty prints all option definition locations

    # Inputs

    `option`
    : The option to pretty print

    # Examples
    :::{.example}
    ## `lib.options.showOptionWithDefLocs` usage example

    ```nix
    showOptionWithDefLocs { loc = ["x" "y" ]; files = [ "foo.nix" "bar.nix" ];  }
    "x.y, with values defined in:\n  - foo.nix\n  - bar.nix\n"
    ```

    ```nix
    nix-repl> eval = lib.evalModules {
        modules = [
          {
            options = {
              foo = lib.mkEnableOption "foo";
            };
          }
        ];
      }

    nix-repl> lib.options.showOptionWithDefLocs eval.options.foo
    "foo, with values defined in:\n  - <unknown-file>\n"
    ```

    :::

    # Type

    ```
    showDefsSep :: { files :: [ String ]; loc :: [ String ]; ... } -> string
    ```
  */
  showOptionWithDefLocs = opt: ''
    ${showOption opt.loc}, with values defined in:
    ${concatMapStringsSep "\n" (defFile: "  - ${defFile}") opt.files}
  '';

  unknownModule = "<unknown-file>";

}
