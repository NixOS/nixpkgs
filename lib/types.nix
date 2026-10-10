/**
  Option types are a way to put constraints on the values a module option
  can take. Types are also responsible of how values are merged in case of
  multiple value definitions.
*/
{ lib }:

let
  inherit (lib)
    all
    elem
    flip
    hasContext
    functionArgs
    isAttrs
    isBool
    isDerivation
    isFloat
    isFunction
    isInt
    isList
    isPath
    isStorePath
    isString
    substring
    sort
    toDerivation
    toList
    types
    ;
  inherit (lib.lists)
    concatLists
    concatMap
    elemAt
    filter
    foldl'
    head
    imap1
    last
    length
    tail
    ;
  inherit (lib.attrsets)
    attrNames
    filterAttrs
    hasAttr
    mapAttrs
    optionalAttrs
    zipAttrsWith
    ;
  inherit (lib.options)
    getFiles
    getValues
    mergeDefaultOption
    mergeEqualOption
    mergeOneOption
    mergeUniqueOption
    showFiles
    showDefs
    showOption
    ;
  inherit (lib.strings)
    concatMapStringsSep
    concatStringsSep
    escapeNixString
    hasInfix
    isStringLike
    ;
  inherit (lib.trivial)
    boolToString
    ;

  inherit (lib.modules)
    mergeDefinitions
    fixupOptionType
    mergeOptionDecls
    defaultOrderPriority
    defaultOverridePriority
    mkDefinition
    mkOrder
    mkOverride
    ;
  inherit (lib.fileset)
    isFileset
    unions
    empty
    ;
  inherit (lib.path) hasStorePathPrefix;

  inAttrPosSuffix =
    v: name:
    let
      pos = builtins.unsafeGetAttrPos name v;
    in
    if pos == null then "" else " at ${pos.file}:${toString pos.line}:${toString pos.column}";

  hasColonInfix = hasInfix ":";
  hasNewlineInfix = hasInfix "\n";

  # Internal functor to help for migrating functor.wrapped to functor.payload.elemType
  # Note that individual attributes can be overridden if needed.
  elemTypeFunctor =
    name:
    { elemType, ... }@payload:
    {
      inherit name payload;
      type = types.${name};
      binOp =
        a: b:
        let
          merged = a.elemType.typeMerge b.elemType.functor;
        in
        if merged == null then null else { elemType = merged; };
    };

  checkDefsForError =
    check: loc: defs:
    if all (def: check def.value) defs then
      null
    else
      let
        invalidDefs = filter (def: !check def.value) defs;
      in
      {
        message = "Definition values: ${showDefs invalidDefs}";
      };

  # Check that a type with v2 merge has a coherent check attribute.
  # Throws an error if the type uses an ad-hoc `type // { check }` override.
  # Returns the last argument like `seq`, allowing usage: checkV2MergeCoherence loc type expr
  checkV2MergeCoherence =
    loc: type: result:
    if type.check.isV2MergeCoherent or false then
      result
    else
      throw ''
        The option `${showOption loc}' has a type `${type.description}' that uses
        an ad-hoc `type // { check = ...; }' override, which is incompatible with
        the v2 merge mechanism.

        Please use `lib.types.addCheck` instead of `type // { check }' to add
        custom validation. For example:

          lib.types.addCheck baseType (value: /* your check */)

        instead of:

          baseType // { check = value: /* your check */; }
      '';

in
rec {
  isType = type: x: (x._type or "") == type;

  setType =
    typeName: value:
    value
    // {
      _type = typeName;
    };

  # Default type merging function
  # takes two type functors and return the merged type
  defaultTypeMerge =
    f: f':
    let
      mergedPayload = f.binOp f.payload f'.payload;

      hasPayload =
        assert (f'.payload != null) == (f.payload != null);
        f.payload != null;
    in
    # Abort early: cannot merge different types
    if f.name != f'.name then
      null
    else

    if hasPayload then
      if mergedPayload == null then null else f.type mergedPayload
    else
      f.type;

  # Default type functor
  defaultFunctor = name: {
    inherit name;
    type = lib.types.${name} or null;
    payload = null;
    binOp = a: b: null;
  };

  isOptionType = isType "option-type";

  /**
    Custom types can be created with the `mkOptionType` function. As type
    creation includes some more complex topics such as submodule handling,
    it is recommended to get familiar with `types.nix` code before creating
    a new type.

    The only required parameter is `name`.

    `name`

    :   A string representation of the type function name.

    `description`

    :   Description of the type used in documentation. Give information of
        the type and any of its arguments.

    `check`

    :   A function to type check the definition value. Takes the definition
        value as a parameter and returns a boolean indicating the type check
        result, `true` for success and `false` for failure.

    `merge`

    :   A function to merge multiple definitions values. Takes two
        parameters:

        *`loc`*

        :   The option path as a list of strings, e.g. `["boot" "loader
                     "grub" "enable"]`.

        *`defs`*

        :   The list of sets of defined `value` and `file` where the value
            was defined, e.g. `[ {
                     file = "/foo.nix"; value = 1; } { file = "/bar.nix"; value = 2 }
                     ]`. The `merge` function should return the merged value
            or throw an error in case the values are impossible or not meant
            to be merged.

    `getSubOptions`

    :   For composed types that can take a submodule as type parameter, this
        function generate sub-options documentation. It takes the current
        option prefix as a list and return the set of sub-options. Usually
        defined in a recursive manner by adding a term to the prefix, e.g.
        `prefix:
              elemType.getSubOptions (prefix ++
              ["prefix"])` where *`"prefix"`* is the newly added prefix.

    `getSubModules`

    :   For composed types that can take a submodule as type parameter, this
        function should return the type parameters submodules. If the type
        parameter is called `elemType`, the function should just recursively
        look into submodules by returning `elemType.getSubModules;`.

    `substSubModules`

    :   For composed types that can take a submodule as type parameter, this
        function can be used to substitute the parameter of a submodule
        type. It takes a module as parameter and return the type with the
        submodule options substituted. It is usually defined as a type
        function call with a recursive call to `substSubModules`, e.g for a
        type `composedType` that take an `elemtype` type parameter, this
        function should be defined as `m:
              composedType (elemType.substSubModules m)`.

    `typeMerge`

    :   A function to merge multiple type declarations. Takes the type to
        merge `functor` as parameter. A `null` return value means that type
        cannot be merged.

        *`f`*

        :   The type to merge `functor`.

        Note: There is a generic `defaultTypeMerge` that work with most of
        value and composed types.

    `functor`

    :   An attribute set representing the type. It is used for type
        operations and has the following keys:

        `type`

        :   The type function.

        `wrapped`

        :   Holds the type parameter for composed types.

        `payload`

        :   Holds the value parameter for value types. The types that have a
            `payload` are the `enum`, `separatedString` and `submodule`
            types.

        `binOp`

        :   A binary operation that can merge the payloads of two same
            types. Defined as a function that take two payloads as
            parameters and return the payloads merged.
  */
  mkOptionType =
    {
      # Human-readable representation of the type, should be equivalent to
      # the type function name.
      name,
      # Description of the type, defined recursively by embedding the wrapped type if any.
      description ? null,
      # A hint for whether or not this description needs parentheses. Possible values:
      #  - "noun": a noun phrase
      #    Example description: "positive integer",
      #  - "conjunction": a phrase with a potentially ambiguous "or" connective
      #    Example description: "int or string"
      #  - "composite": a phrase with an "of" connective
      #    Example description: "list of string"
      #  - "nonRestrictiveClause": a noun followed by a comma and a clause
      #    Example description: "positive integer, meaning >0"
      # See the `optionDescriptionPhrase` function.
      descriptionClass ? null,
      # DO NOT USE WITHOUT KNOWING WHAT YOU ARE DOING!
      # Function applied to each definition that must return false when a definition
      # does not match the type. It should not check more than the root of the value,
      # because checking nested values reduces laziness, leading to unnecessary
      # infinite recursions in the module system.
      # Further checks of nested values should be performed by throwing in
      # the merge function.
      # Strict and deep type checking can be performed by calling lib.deepSeq on
      # the merged value.
      #
      # See https://github.com/NixOS/nixpkgs/pull/6794 that introduced this change,
      # https://github.com/NixOS/nixpkgs/pull/173568 and
      # https://github.com/NixOS/nixpkgs/pull/168295 that attempted to revert this,
      # https://github.com/NixOS/nixpkgs/issues/191124 and
      # https://github.com/NixOS/nixos-search/issues/391 for what happens if you ignore
      # this disclaimer.
      check ? (x: true),
      # Merge a list of definitions together into a single value.
      # This function is called with two arguments: the location of
      # the option in the configuration as a list of strings
      # (e.g. ["boot" "loader "grub" "enable"]), and a list of
      # definition values and locations (e.g. [ { file = "/foo.nix";
      # value = 1; } { file = "/bar.nix"; value = 2 } ]).
      merge ? mergeDefaultOption,
      # Whether this type has a value representing nothingness. If it does,
      # this should be a value of the form { value = <the nothing value>; }
      # If it doesn't, this should be {}
      # This may be used when a value is required for `mkIf false`. This allows the extra laziness in e.g. `lazyAttrsOf`.
      emptyValue ? { },
      # Return a flat attrset of sub-options.  Used to generate
      # documentation.
      getSubOptions ? prefix: { },
      # List of modules if any, or null if none.
      getSubModules ? null,
      # Function for building the same option type with a different list of
      # modules.
      substSubModules ? m: null,
      # Function that merge type declarations.
      # internal, takes a functor as argument and returns the merged type.
      # returning null means the type is not mergeable
      typeMerge ? defaultTypeMerge functor,
      # The type functor.
      # internal, representation of the type as an attribute set.
      #   name: name of the type
      #   type: type function.
      #   wrapped: the type wrapped in case of compound types.
      #   payload: values of the type, two payloads of the same type must be
      #            combinable with the binOp binary operation.
      #   binOp: binary operation that merge two payloads of the same type.
      functor ? defaultFunctor name,
      # The deprecation message to display when this type is used by an option
      # If null, the type isn't deprecated
      deprecationMessage ? null,
      # The types that occur in the definition of this type. This is used to
      # issue deprecation warnings recursively. Can also be used to reuse
      # nested types
      nestedTypes ? { },
    }:
    {
      _type = "option-type";
      inherit
        name
        check
        merge
        emptyValue
        getSubOptions
        getSubModules
        substSubModules
        typeMerge
        deprecationMessage
        nestedTypes
        descriptionClass
        functor
        ;
      description = if description == null then name else description;
    };

  # optionDescriptionPhrase :: (str -> bool) -> optionType -> str
  #
  # Helper function for producing unambiguous but readable natural language
  # descriptions of types.
  #
  # Parameters
  #
  #     optionDescriptionPhase unparenthesize optionType
  #
  # `unparenthesize`: A function from descriptionClass string to boolean.
  #   It must return true when the class of phrase will fit unambiguously into
  #   the description of the caller.
  #
  # `optionType`: The option type to parenthesize or not.
  #   The option whose description we're returning.
  #
  # Returns value
  #
  # The description of the `optionType`, with parentheses if there may be an
  # ambiguity.
  optionDescriptionPhrase =
    unparenthesize: t:
    if unparenthesize (t.descriptionClass or null) then t.description else "(${t.description})";

  noCheckForDocsModule = {
    # When generating documentation, our goal isn't to check anything.
    # Quite the opposite in fact. Generating docs is somewhat of a
    # challenge, evaluating modules in a *lacking* context. Anything
    # that makes the docs avoid an error is a win.
    config._module.check = lib.mkForce false;
    _file = "<built-in module that disables checks for the purpose of documentation generation>";
  };

  /**
    A type which doesn't do any checking, merging or nested evaluation. It
    accepts a single arbitrary value that is not recursed into, making it
    useful for values coming from outside the module system, such as package
    sets or arbitrary data. Options of this type are still evaluated according
    to priorities and conditionals, so `mkForce`, `mkIf` and co. still work on
    the option value itself, but not for any value nested within it. This type
    should only be used when checking, merging and nested evaluation are not
    desirable.
  */
  raw = mkOptionType {
    name = "raw";
    description = "raw value";
    descriptionClass = "noun";
    check = value: true;
    merge = mergeOneOption;
  };

  /**
    A type that accepts any value and recursively merges attribute sets
    together. This type is recommended when the option type is unknown.

    ::: {.example}
    # `types.anything`

    Two definitions of this type like

    ```nix
    {
      str = lib.mkDefault "foo";
      pkg.hello = pkgs.hello;
      fun.fun = x: x + 1;
    }
    ```

    ```nix
    {
      str = lib.mkIf true "bar";
      pkg.gcc = pkgs.gcc;
      fun.fun = lib.mkForce (x: x + 2);
    }
    ```

    will get merged to

    ```nix
    {
      str = "bar";
      pkg.gcc = pkgs.gcc;
      pkg.hello = pkgs.hello;
      fun.fun = x: x + 2;
    }
    ```
    :::
  */
  anything = mkOptionType {
    name = "anything";
    description = "anything";
    descriptionClass = "noun";
    check = value: true;
    merge =
      loc: defs:
      let
        getType =
          value: if isAttrs value && isStringLike value then "stringCoercibleSet" else builtins.typeOf value;

        # Returns the common type of all definitions, throws an error if they
        # don't have the same type
        commonType = foldl' (
          type: def:
          if getType def.value == type then
            type
          else
            throw "The option `${showOption loc}' has conflicting option types in ${showFiles (getFiles defs)}"
        ) (getType (head defs).value) defs;

        mergeFunction =
          {
            # Recursively merge attribute sets
            set = (attrsOf anything).merge;
            # This is the type of packages, only accept a single definition
            stringCoercibleSet = mergeOneOption;
            lambda =
              loc: defs: arg:
              anything.merge (loc ++ [ "<function body>" ]) (
                map (def: {
                  file = def.file;
                  value = def.value arg;
                }) defs
              );
            # Otherwise fall back to only allowing all equal definitions
          }
          .${commonType} or mergeEqualOption;
      in
      mergeFunction loc defs;
  };

  unspecified = mkOptionType {
    name = "unspecified";
    description = "unspecified value";
    descriptionClass = "noun";
  };

  /**
    A boolean, its values can be `true` or `false`.
    All definitions must have the same value, after priorities. An error is thrown in case of a conflict.
  */
  bool = mkOptionType {
    name = "bool";
    description = "boolean";
    descriptionClass = "noun";
    check = isBool;
    merge = mergeEqualOption;
  };

  /**
    A boolean, its values can be `true` or `false`.
    The result is `true` if _any_ of multiple definitions is `true`.
    In other words, definitions are merged with the logical _OR_ operator.
  */
  boolByOr = mkOptionType {
    name = "boolByOr";
    description = "boolean (merged using or)";
    descriptionClass = "noun";
    check = isBool;
    merge =
      loc: defs:
      foldl' (
        result: def:
        # Under the assumption that .check always runs before merge, we can assume that all defs.*.value
        # have been forced, and therefore we assume we don't introduce order-dependent strictness here
        result || def.value
      ) false defs;
  };

  /**
    A signed integer.
  */
  int = mkOptionType {
    name = "int";
    description = "signed integer";
    descriptionClass = "noun";
    check = isInt;
    merge = mergeEqualOption;
  };

  /**
    `types.ints.{s8, s16, s32}`

    :   Signed integers with a fixed length (8, 16 or 32 bits). They go from
        −2^n/2 to
        2^n/2−1 respectively (e.g. `−128` to
        `127` for 8 bits).

    `types.ints.unsigned`

    :   An unsigned integer (that is >= 0).

    `types.ints.{u8, u16, u32}`

    :   Unsigned integers with a fixed length (8, 16 or 32 bits). They go
        from 0 to 2^n−1 respectively (e.g. `0`
        to `255` for 8 bits).

    `types.ints.between` *`lowest highest`*

    :   An integer between *`lowest`* and *`highest`* (both inclusive).

        :::{.example}
        # `lib.types.ints.between` usage example

        ```nix
        (ints.between 0 100).check (-1)
        => false
        (ints.between 0 100).check (101)
        => false
        (ints.between 0 0).check 0
        => true
        ```

        :::

    `types.ints.positive`

    :   A positive integer (that is > 0).
  */
  ints =
    let
      betweenDesc = lowest: highest: "${toString lowest} and ${toString highest} (both inclusive)";
      between =
        lowest: highest:
        assert lowest <= highest || throw "ints.between: lowest must be smaller than highest";
        addCheck int (x: x >= lowest && x <= highest)
        // {
          name = "intBetween";
          description = "integer between ${betweenDesc lowest highest}";
        };
      ign =
        lowest: highest: name: docStart:
        between lowest highest
        // {
          inherit name;
          description = docStart + "; between ${betweenDesc lowest highest}";
        };
      unsign =
        bit: range: ign 0 (range - 1) "unsignedInt${toString bit}" "${toString bit} bit unsigned integer";
      sign =
        bit: range:
        ign (0 - (range / 2)) (
          range / 2 - 1
        ) "signedInt${toString bit}" "${toString bit} bit signed integer";

    in
    {
      inherit between;

      unsigned = addCheck lib.types.int (x: x >= 0) // {
        name = "unsignedInt";
        description = "unsigned integer, meaning >=0";
        descriptionClass = "nonRestrictiveClause";
      };
      positive = addCheck lib.types.int (x: x > 0) // {
        name = "positiveInt";
        description = "positive integer, meaning >0";
        descriptionClass = "nonRestrictiveClause";
      };
      u8 = unsign 8 256;
      u16 = unsign 16 65536;
      # the biggest int Nix accepts is 2^63 - 1 (9223372036854775807)
      # the smallest int Nix accepts is -2^63 (-9223372036854775808)
      u32 = unsign 32 4294967296;
      # u64 = unsign 64 18446744073709551616;

      s8 = sign 8 256;
      s16 = sign 16 65536;
      s32 = sign 32 4294967296;
    };

  /**
    A port number. This type is an alias to
    `types.ints.u16`.
  */
  port = ints.u16;

  /**
    A floating point number.

    ::: {.warning}
    Converting a floating point number to a string with `toString` or `toJSON`
    may result in [precision loss](https://github.com/NixOS/nix/issues/5733).
    :::
  */
  float = mkOptionType {
    name = "float";
    description = "floating point number";
    descriptionClass = "noun";
    check = isFloat;
    merge = mergeEqualOption;
  };

  /**
    Either a signed integer or a floating point number. No implicit conversion
    is done between the two types, and multiple equal definitions will only be
    merged if they have the same type.
  */
  number = either int float;

  /**
    `types.numbers.between` *`lowest highest`*

    :   An integer or floating point number between *`lowest`* and *`highest`* (both inclusive).

    `types.numbers.nonnegative`

    :   A nonnegative integer or floating point number (that is >= 0).

    `types.numbers.positive`

    :   A positive integer or floating point number (that is > 0).
  */
  numbers =
    let
      betweenDesc =
        lowest: highest: "${builtins.toJSON lowest} and ${builtins.toJSON highest} (both inclusive)";
    in
    {
      between =
        lowest: highest:
        assert lowest <= highest || throw "numbers.between: lowest must be smaller than highest";
        addCheck number (x: x >= lowest && x <= highest)
        // {
          name = "numberBetween";
          description = "integer or floating point number between ${betweenDesc lowest highest}";
        };

      nonnegative = addCheck number (x: x >= 0) // {
        name = "numberNonnegative";
        description = "nonnegative integer or floating point number, meaning >=0";
        descriptionClass = "nonRestrictiveClause";
      };
      positive = addCheck number (x: x > 0) // {
        name = "numberPositive";
        description = "positive integer or floating point number, meaning >0";
        descriptionClass = "nonRestrictiveClause";
      };
    };

  /**
    A string. Multiple definitions cannot be merged.
  */
  str = mkOptionType {
    name = "str";
    description = "string";
    descriptionClass = "noun";
    check = isString;
    merge = mergeEqualOption;
  };

  nonEmptyStr = mkOptionType {
    name = "nonEmptyStr";
    description = "non-empty string";
    descriptionClass = "noun";
    check = x: str.check x && builtins.match "[ \t\n]*" x == null;
    inherit (str) merge;
  };

  # Allow a newline character at the end and trim it in the merge function.
  singleLineStr =
    let
      inherit (strMatching "[^\n\r]*\n?") check merge;
      removeNewlineSuffix = lib.removeSuffix "\n";
    in
    mkOptionType {
      name = "singleLineStr";
      description = "(optionally newline-terminated) single-line string";
      descriptionClass = "noun";
      inherit check;
      merge = loc: defs: removeNewlineSuffix (merge loc defs);
    };

  /**
    A string matching a specific regular expression. Multiple
    definitions cannot be merged. The regular expression is processed
    using `builtins.match`.
  */
  strMatching =
    pattern:
    mkOptionType {
      name = "strMatching ${escapeNixString pattern}";
      description = "string matching the pattern ${pattern}";
      descriptionClass = "noun";
      check = x: str.check x && builtins.match pattern x != null;
      inherit (str) merge;
      functor = defaultFunctor "strMatching" // {
        type = payload: strMatching payload.pattern;
        payload = { inherit pattern; };
        binOp = lhs: rhs: if lhs == rhs then lhs else null;
      };
    };

  /**
    `types.separatedString` *`sep`*

    A string. Multiple definitions are concatenated with *`sep`*, e.g.
    `types.separatedString "|"`.
  */
  separatedString =
    sep:
    mkOptionType rec {
      name = "separatedString";
      description = "strings concatenated with ${builtins.toJSON sep}";
      descriptionClass = "noun";
      check = isString;
      merge = loc: defs: concatStringsSep sep (getValues defs);
      functor = (defaultFunctor name) // {
        payload = { inherit sep; };
        type = payload: lib.types.separatedString payload.sep;
        binOp = lhs: rhs: if lhs.sep == rhs.sep then { inherit (lhs) sep; } else null;
      };
    };

  /**
    A string. Multiple definitions are concatenated with a new line
    `"\n"`.
  */
  lines = separatedString "\n";

  /**
    A string. Multiple definitions are concatenated with a comma `","`.
  */
  commas = separatedString ",";

  /**
    A string. Multiple definitions are concatenated with a colon `":"`.
  */
  envVar = separatedString ":";

  passwdEntry =
    entryType:
    addCheck entryType (str: !(hasColonInfix str || hasNewlineInfix str))
    // {
      name = "passwdEntry ${entryType.name}";
      description = "${
        optionDescriptionPhrase (class: class == "noun") entryType
      }, not containing newlines or colons";
      descriptionClass = "nonRestrictiveClause";
    };

  /**
    A free-form attribute set.

    ::: {.warning}
    This type will be deprecated in the future because it doesn't
    recurse into attribute sets, silently drops earlier attribute
    definitions, and doesn't discharge `lib.mkDefault`, `lib.mkIf`
    and co. For allowing arbitrary attribute sets, prefer
    `types.attrsOf types.anything` instead which doesn't have these
    problems.
    :::
  */
  attrs = mkOptionType {
    name = "attrs";
    description = "attribute set";
    check = isAttrs;
    merge = loc: foldl' (res: def: res // def.value) { };
    emptyValue = {
      value = { };
    };
  };

  fileset = mkOptionType {
    name = "fileset";
    description = "fileset";
    descriptionClass = "noun";
    check = isFileset;
    merge = loc: defs: unions (getValues defs);
    emptyValue.value = empty;
  };

  # A package is a top-level store path (/nix/store/hash-name). This includes:
  # - derivations
  # - more generally, attribute sets with an `outPath` or `__toString` attribute
  #   pointing to a store path, e.g. flake inputs
  # - strings with context, e.g. "${pkgs.foo}" or (toString pkgs.foo)
  # - hardcoded store path literals (/nix/store/hash-foo) or strings without context
  #   ("/nix/store/hash-foo"). These get a context added to them using builtins.storePath.
  # If you don't need a *top-level* store path, consider using pathInStore instead.

  /**
    A top-level store path. This can be an attribute set pointing
    to a store path, like a derivation or a flake input.
  */
  package = mkOptionType {
    name = "package";
    descriptionClass = "noun";
    check = x: isDerivation x || isStorePath x;
    merge =
      loc: defs:
      let
        res = mergeOneOption loc defs;
      in
      if isPath res || (isString res && !hasContext res) then toDerivation res else res;
  };

  shellPackage = package // {
    check = x: isDerivation x && hasAttr "shellPath" x;
  };

  /**
    A type for the top level Nixpkgs package set.
  */
  pkgs = addCheck (
    unique { message = "A Nixpkgs pkgs set can not be merged with another pkgs set."; } attrs
    // {
      name = "pkgs";
      descriptionClass = "noun";
      description = "Nixpkgs package set";
    }
  ) (x: (x._type or null) == "pkgs");

  /**
    A filesystem path that starts with a slash. Even if derivations can be
     considered as paths, the more specific `types.package` should be preferred.
  */
  path = pathWith {
    absolute = true;
  };

  /**
    A path that is contained in the Nix store. This can be a top-level store
    path like `pkgs.hello` or a descendant like `"${pkgs.hello}/bin/hello"`.
  */
  pathInStore = pathWith {
    inStore = true;
  };

  /**
    A path that is not contained in the Nix store. Typical use cases are:
    secrets, password or any other external file.

    ::: {.warning}
    This type only validates that the path is not *currently* in the Nix store.
    It does NOT prevent the value from being copied to the store later when:
    - Referenced in a derivation
    - Used in certain path operations (e.g., `${path}` interpolation)
    - Passed to functions that copy to the store

    Users must still be careful about how they reference these paths.
    :::
  */
  externalPath = pathWith {
    absolute = true;
    inStore = false;
  };

  /**
    `types.pathWith` { *`inStore`* ? `null`, *`absolute`* ? `null` }

    A filesystem path. Either a string or something that can be coerced
    to a string.

    **Parameters**

    `inStore` (`Boolean` or `null`, default `null`)
    : Whether the path must be in the store (`true`), must not be in the store
      (`false`), or it doesn't matter (`null`)

    `absolute` (`Boolean` or `null`, default `null`)
    : Whether the path must be absolute (`true`), must not be absolute
      (`false`), or it doesn't matter (`null`)

    **Behavior**
    - `pathWith { inStore = true; }` is equivalent to `pathInStore`
    - `pathWith { absolute = true; }` is equivalent to `path`
    - `pathWith { inStore = false; absolute = true; }` requires an absolute
      path that is not in the store. Useful for password files that shouldn't be
      leaked into the store.
  */
  pathWith =
    {
      inStore ? null,
      absolute ? null,
    }:
    if inStore != null && absolute != null && inStore && !absolute then
      throw "In pathWith, inStore means the path must be absolute"
    else
      mkOptionType {
        name = "path";
        description = (
          (if absolute == null then "" else (if absolute then "absolute " else "relative "))
          + "path"
          + (
            if inStore == null then "" else (if inStore then " in the Nix store" else " not in the Nix store")
          )
        );
        descriptionClass = "noun";

        merge = mergeEqualOption;
        functor = defaultFunctor "path" // {
          type = pathWith;
          payload = { inherit inStore absolute; };
          binOp = lhs: rhs: if lhs == rhs then lhs else null;
        };

        check =
          x:
          let
            isInStore = hasStorePathPrefix (
              if isPath x then
                x
              # Discarding string context is necessary to convert the value to
              # a path and safe as the result is never used in any derivation.
              else
                /. + builtins.unsafeDiscardStringContext x
            );
            isAbsolute = x.type or null == "derivation" || substring 0 1 (toString x) == "/";
            isExpectedType = (
              if inStore == null || inStore then isStringLike x else isString x # Do not allow a true path, which could be copied to the store later on.
            );
          in
          isExpectedType
          && (inStore == null || inStore == isInStore)
          && (absolute == null || absolute == isAbsolute);
      };

  /**
    `types.listOf` *`t`*

    A list of *`t`* type, e.g. `types.listOf
          int`. Multiple definitions are merged with list concatenation.
  */
  listOf =
    elemType:
    mkOptionType rec {
      name = "listOf";
      description = "list of ${
        optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
      descriptionClass = "composite";
      check = {
        __functor = _self: isList;
        isV2MergeCoherent = true;
      };
      merge = {
        __functor =
          self: loc: defs:
          (self.v2 { inherit loc defs; }).value;
        v2 =
          { loc, defs }:
          let
            evals = filter (x: x.optionalValue ? value) (
              concatLists (
                imap1 (
                  n: def:
                  imap1 (
                    m: def':
                    (mergeDefinitions (loc ++ [ "[definition ${toString n}-entry ${toString m}]" ]) elemType [
                      {
                        inherit (def) file;
                        value = def';
                      }
                    ])
                  ) def.value
                ) defs
              )
            );
          in
          {
            headError = checkDefsForError check loc defs;
            value = map (x: x.optionalValue.value or x.mergedValue) evals;
            valueMeta.list = map (v: v.checkedAndMerged.valueMeta) evals;
          };
      };
      emptyValue = {
        value = [ ];
      };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ [ "*" ]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: listOf (elemType.substSubModules m);
      functor = (elemTypeFunctor name { inherit elemType; }) // {
        type = payload: lib.types.listOf payload.elemType;
      };
      nestedTypes.elemType = elemType;
    };

  nonEmptyListOf =
    elemType:
    let
      list = addCheck (lib.types.listOf elemType) (l: l != [ ]);
    in
    list
    // {
      description = "non-empty ${optionDescriptionPhrase (class: class == "noun") list}";
      emptyValue = { }; # no .value attr, meaning unset
      substSubModules = m: nonEmptyListOf (elemType.substSubModules m);
    };

  /**
    `types.attrListOf` *`t`*

    An ordered list of single-attribute attribute sets, where each value is of *`t`* type.
    The output is always `[ { name1 = value1; } { name2 = value2; } ... ]`.

    Definitions can be provided in two formats, which may be mixed via `lib.mkMerge`, `imports`, etc:

    - **List format**: `[ { a = 1; } { b = 2; } ]` — each element must be a single-attribute attribute set.
      Elements may be wrapped in `lib.mkOrder` (or `lib.mkBefore`/`lib.mkAfter`) to control ordering;
      unwrapped elements use the default order priority.

    - **Attribute set format**: `{ a = lib.mkOrder 100 1; b = 2; }` — each name-value pair becomes a single-attribute attribute set in the output.
      Values may be wrapped in `lib.mkOrder` (or `lib.mkBefore`/`lib.mkAfter`) to control ordering.
      Values without `lib.mkOrder` use the default priority.

    Multiple definitions of the same option are concatenated and then sorted by priority.
    Entries at the same priority level preserve their definition order.
  */
  attrListOf = elemType: attrListWith { inherit elemType; };

  /**
    `types.attrListWith` { *`elemType`*, *`asAttrs`* ? false, *`mergeAttrValues`* ? _name: values: values }

    An ordered list of single-attribute attribute sets, where each value is of *`elemType`* type.

    **Parameters**

    `elemType` (Required)
    : Specifies the type of each value in the attribute list.

    `asAttrs`
    : When `true`, the option value is an attribute set instead of a list.
      Duplicate keys are merged using `mergeAttrValues`.
      The ordered list is always available via `valueMeta.attrListValue`.

    `mergeAttrValues`
    : A function `name: values: mergedValue` that controls how duplicate keys
      are combined when `asAttrs = true`. This is passed as the callback to
      `lib.zipAttrsWith`. The `values` list is in order of priority.
      By default, all values are collected into a list.

    **Behavior**

    - `attrListWith { elemType = t; }` is equivalent to `attrListOf t`
  */
  attrListWith =
    {
      elemType,
      asAttrs ? false,
      mergeAttrValues ? _name: values: values,
    }:
    mkOptionType rec {
      name = "attrListOf";
      description = "attribute list of ${
        optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
      descriptionClass = "composite";
      check = {
        __functor = _self: x: isList x || isAttrs x;
        isV2MergeCoherent = true;
      };
      merge = {
        __functor =
          self: loc: defs:
          (self.v2 { inherit loc defs; }).value;
        v2 =
          { loc, defs }:
          let
            # Peel order and override properties from a value in any nesting order.
            # Returns { value, prio, overridePrio }.
            # mkOrder is stripped (we consume it for sorting).
            # mkOverride is preserved in value (mergeDefinitions strips it).
            peelProperties =
              value:
              let
                type = value._type or null;
              in
              if type == "order" then
                let
                  inner = peelProperties value.content;
                in
                {
                  inherit (inner) value overridePrio;
                  prio = value.priority;
                }
              else if type == "override" then
                let
                  inner = peelProperties value.content;
                in
                {
                  inherit (inner) prio;
                  overridePrio = value.priority;
                  # Re-wrap mkOverride around the inner value (with mkOrder stripped)
                  value = mkOverride value.priority inner.value;
                }
              else
                {
                  inherit value;
                  prio = defaultOrderPriority;
                  overridePrio = defaultOverridePriority;
                };

            # Extract { file, key, value, prio, overridePrio } from a single-key attrset,
            # optionally wrapped in mkOrder at the element level (list format).
            extractItem =
              file: raw:
              let
                hasOrder = isType "order" raw;
                item = if hasOrder then raw.content else raw;
                key = head (attrNames item);
                peeled = peelProperties item.${key};
              in
              if isAttrs item && length (attrNames item) == 1 then
                peeled
                // {
                  inherit file key;
                  prio = if hasOrder then raw.priority else peeled.prio;
                }
              else
                throw "A definition for option `${showOption loc}' is not of type `${description}'. ${
                  if !isAttrs item then
                    "Each list element must be an attribute set, but got ${builtins.typeOf item}"
                  else
                    "Each list element must be a single-key attribute set, but got ${toString (length (attrNames item))} keys"
                }.${
                  showDefs [
                    {
                      inherit file;
                      value = raw;
                    }
                  ]
                }";

            # Convert a definition to a flat list of { file, key, value, prio, overridePrio }
            defToItems =
              def:
              if isList def.value then
                map (extractItem def.file) def.value
              else
                # isAttrs: properties are on the values directly
                map (
                  key:
                  peelProperties def.value.${key}
                  // {
                    inherit (def) file;
                    inherit key;
                  }
                ) (attrNames def.value);

            allItems = concatMap defToItems defs;

            # Per key, find the highest override priority (lowest number)
            winningOverridePrio = foldl' (
              acc: item:
              let
                prev = acc.${item.key} or defaultOverridePriority;
              in
              if item.overridePrio < prev then
                acc // { ${item.key} = item.overridePrio; }
              else
                # minimize `//` operations
                acc
            ) { } allItems;

            # Keep only items at the winning override priority for their key
            items = sort (a: b: a.prio < b.prio) (
              filter (
                item: item.overridePrio == winningOverridePrio.${item.key} or defaultOverridePriority
              ) allItems
            );

            evals = filter (e: e.eval.optionalValue ? value) (
              map (item: {
                inherit (item) key file prio;
                eval = mergeDefinitions (loc ++ [ item.key ]) elemType [
                  {
                    inherit (item) file value;
                  }
                ];
              }) items
            );

            attrListValue = map (e: { ${e.key} = e.eval.optionalValue.value or e.eval.mergedValue; }) evals;
          in
          {
            headError = checkDefsForError check loc defs;
            value = if asAttrs then zipAttrsWith mergeAttrValues attrListValue else attrListValue;
            valueMeta.attrList = map (e: e.eval.checkedAndMerged.valueMeta) evals;
            /**
              The ordered list representation, especially useful when asAttrs is set.
            */
            valueMeta.attrListValue = attrListValue;
            valueMeta.definitions = map (
              e:
              mkDefinition {
                inherit (e) file;
                value = mkOrder e.prio { ${e.key} = e.eval.optionalValue.value or e.eval.mergedValue; };
              }
            ) evals;
          };
      };
      emptyValue = {
        value = if asAttrs then { } else [ ];
      };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ [ "*" ]);
      getSubModules = elemType.getSubModules;
      substSubModules =
        m:
        attrListWith {
          inherit asAttrs mergeAttrValues;
          elemType = elemType.substSubModules m;
        };
      typeMerge = t: null; # Disable type merging
      nestedTypes.elemType = elemType;
    };

  /**
    `types.attrsOf` *`t`*

    An attribute set of where all the values are of *`t`* type. Multiple
    definitions result in the joined attribute set.

    ::: {.note}
    This type is *strict* in its values, which in turn means attributes
    cannot depend on other attributes. See `
           types.lazyAttrsOf` for a lazy version.
    :::
  */
  attrsOf = elemType: attrsWith { inherit elemType; };

  /**
    `types.lazyAttrsOf` *`t`*

    An attribute set of where all the values are of *`t`* type. Multiple
    definitions result in the joined attribute set. This is the lazy
    version of `types.attrsOf
          `, allowing attributes to depend on each other.

    ::: {.warning}
    This version does not fully support conditional definitions! With an
    option `foo` of this type and a definition
    `foo.attr = lib.mkIf false 10`, evaluating `foo ? attr` will return
    `true` even though it should be false. Accessing the value will then
    throw an error. For types *`t`* that have an `emptyValue` defined,
    that value will be returned instead of throwing an error. So if the
    type of `foo.attr` was `lazyAttrsOf (nullOr int)`, `null` would be
    returned instead for the same `mkIf false` definition.
    :::
  */
  lazyAttrsOf =
    elemType:
    attrsWith {
      inherit elemType;
      lazy = true;
    };

  /**
    `types.attrsWith` { *`elemType`*, *`lazy`* ? false, *`placeholder`* ? "name" }

    An attribute set of where all the values are of *`elemType`* type.

    **Parameters**

    `elemType` (Required)
    : Specifies the type of the values contained in the attribute set.

    `lazy`
    : Determines whether the attribute set is lazily evaluated. See: `types.lazyAttrsOf`

    `placeholder` (`String`, default: `name` )
    : Placeholder string in documentation for the attribute names.
      The default value `name` results in the placeholder `<name>`

    **Behavior**

    - `attrsWith { elemType = t; }` is equivalent to `attrsOf t`
    - `attrsWith { lazy = true; elemType = t; }` is equivalent to `lazyAttrsOf t`
    - `attrsWith { placeholder = "id"; elemType = t; }`

      Displays the option as `foo.<id>` in the manual.
  */
  attrsWith =
    let
      # Push down position info.
      pushPositions = map (
        def:
        mapAttrs (n: v: {
          inherit (def) file;
          value = v;
        }) def.value
      );
      binOp =
        lhs: rhs:
        let
          elemType = lhs.elemType.typeMerge rhs.elemType.functor;
          lazy = if lhs.lazy == rhs.lazy then lhs.lazy else null;
          placeholder =
            if lhs.placeholder == rhs.placeholder then
              lhs.placeholder
            else if lhs.placeholder == "name" then
              rhs.placeholder
            else if rhs.placeholder == "name" then
              lhs.placeholder
            else
              null;
        in
        if elemType == null || lazy == null || placeholder == null then
          null
        else
          {
            inherit elemType lazy placeholder;
          };
    in
    {
      elemType,
      lazy ? false,
      placeholder ? "name",
    }:
    mkOptionType rec {
      name = if lazy then "lazyAttrsOf" else "attrsOf";
      description =
        (if lazy then "lazy attribute set" else "attribute set")
        + " of ${optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType}";
      descriptionClass = "composite";
      check = {
        __functor = _self: isAttrs;
        isV2MergeCoherent = true;
      };
      merge = {
        __functor =
          self: loc: defs:
          (self.v2 { inherit loc defs; }).value;
        v2 =
          { loc, defs }:
          let
            evals =
              if lazy then
                zipAttrsWith (name: defs: mergeDefinitions (loc ++ [ name ]) elemType defs) (pushPositions defs)
              else
                # Filtering makes the merge function more strict
                # Meaning it is less lazy
                filterAttrs (n: v: v.optionalValue ? value) (
                  zipAttrsWith (name: defs: mergeDefinitions (loc ++ [ name ]) elemType defs) (pushPositions defs)
                );
          in
          {
            headError = checkDefsForError check loc defs;
            value = mapAttrs (
              n: v:
              if lazy then
                v.optionalValue.value or elemType.emptyValue.value or v.mergedValue
              else
                v.optionalValue.value
            ) evals;
            valueMeta.attrs = mapAttrs (n: v: v.checkedAndMerged.valueMeta) evals;
          };
      };

      emptyValue = {
        value = { };
      };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ [ "<${placeholder}>" ]);
      getSubModules = elemType.getSubModules;
      substSubModules =
        m:
        attrsWith {
          elemType = elemType.substSubModules m;
          inherit lazy placeholder;
        };
      functor =
        (elemTypeFunctor "attrsWith" {
          inherit elemType lazy placeholder;
        })
        // {
          # Custom type merging required because of the "placeholder" attribute
          inherit binOp;
        };
      nestedTypes.elemType = elemType;
    };

  # TODO: deprecate this in the future:
  loaOf =
    elemType:
    lib.types.attrsOf elemType
    // {
      name = "loaOf";
      deprecationMessage =
        "Mixing lists with attribute values is no longer"
        + " possible; please use `types.attrsOf` instead. See"
        + " https://github.com/NixOS/nixpkgs/issues/1800 for the motivation.";
      nestedTypes.elemType = elemType;
    };

  /**
    `types.attrTag` *`{ attr1 = option1; attr2 = option2; ... }`*

    An attribute set containing one attribute, whose name must be picked from
    the attribute set (`attr1`, etc) and whose value consists of definitions that are valid for the corresponding option (`option1`, etc).

    This type appears in the documentation as _attribute-tagged union_.

    Example:

    ```nix
    { lib, ... }:
    let inherit (lib) type mkOption;
    in {
      options.toyRouter.rules = mkOption {
        description = ''
          Rules for a fictional packet routing service.
        '';
        type = types.attrsOf (
          types.attrTag {
            bounce = mkOption {
              description = "Send back a packet explaining why it wasn't forwarded.";
              type = types.submodule {
                options.errorMessage = mkOption { … };
              };
            };
            forward = mkOption {
              description = "Forward the packet.";
              type = types.submodule {
                options.destination = mkOption { … };
              };
            };
            drop = types.mkOption {
              description = "Drop the packet without sending anything back.";
              type = types.submodule {};
            };
          });
      };
      config.toyRouter.rules = {
        http = {
          bounce = {
            errorMessage = "Unencrypted HTTP is banned. You must always use https://.";
          };
        };
        ssh = { drop = {}; };
      };
    }
    ```
  */
  attrTag =
    tags:
    let
      tags_ = tags;
    in
    let
      tags = mapAttrs (
        n: opt:
        builtins.addErrorContext
          "while checking that attrTag tag ${lib.strings.escapeNixIdentifier n} is an option with a type${inAttrPosSuffix tags_ n}"
          (
            if opt._type or null != "option" then
              throw "In attrTag, each tag value must be an option, but tag ${lib.strings.escapeNixIdentifier n} ${
                if opt ? _type then
                  if opt._type == "option-type" then
                    "was a bare type, not wrapped in mkOption."
                  else
                    "was of type ${lib.strings.escapeNixString opt._type}."
                else
                  "was not."
              }"
            else
              opt
              // {
                declarations =
                  opt.declarations or (
                    let
                      pos = builtins.unsafeGetAttrPos n tags_;
                    in
                    if pos == null then [ ] else [ pos.file ]
                  );
                declarationPositions =
                  opt.declarationPositions or (
                    let
                      pos = builtins.unsafeGetAttrPos n tags_;
                    in
                    if pos == null then [ ] else [ pos ]
                  );
              }
          )
      ) tags_;
      choicesStr = concatMapStringsSep ", " lib.strings.escapeNixIdentifier (attrNames tags);
    in
    mkOptionType {
      name = "attrTag";
      description = "attribute-tagged union with choices: ${choicesStr}";
      descriptionClass = "noun";
      getSubOptions =
        prefix: mapAttrs (tagName: tagOption: tagOption // { loc = prefix ++ [ tagName ]; }) tags;
      check = v: isAttrs v && length (attrNames v) == 1 && tags ? ${head (attrNames v)};
      merge =
        loc: defs:
        let
          choice = head (attrNames (head defs).value);
          checkedValueDefs = map (
            def:
            assert (length (attrNames def.value)) == 1;
            if (head (attrNames def.value)) != choice then
              throw "The option `${showOption loc}` is defined both as `${choice}` and `${head (attrNames def.value)}`, in ${showFiles (getFiles defs)}."
            else
              {
                inherit (def) file;
                value = def.value.${choice};
              }
          ) defs;
        in
        if tags ? ${choice} then
          {
            ${choice} = (lib.modules.evalOptionValue (loc ++ [ choice ]) tags.${choice} checkedValueDefs).value;
          }
        else
          throw "The option `${showOption loc}` is defined as ${lib.strings.escapeNixIdentifier choice}, but ${lib.strings.escapeNixIdentifier choice} is not among the valid choices (${choicesStr}). Value ${choice} was defined in ${showFiles (getFiles defs)}.";
      nestedTypes = tags;
      getSubModules =
        let
          tagsWithSubModules = filterAttrs (_: mods: mods != null) (
            mapAttrs (_: opt: opt.type.getSubModules) tags
          );
        in
        if tagsWithSubModules == { } then null else [ tagsWithSubModules ];
      substSubModules =
        allWrappedModules:
        let
          tagsWithNewTypes = zipAttrsWith (tag: tags.${tag}.type.substSubModules) (
            concatMap (
              { _file, imports }: map (mapAttrs (_: imports: { inherit _file imports; })) imports
            ) allWrappedModules
          );
        in
        attrTag (
          mapAttrs (
            tag: opt: opt // (optionalAttrs (tagsWithNewTypes ? ${tag}) { type = tagsWithNewTypes.${tag}; })
          ) tags
        );
      functor = defaultFunctor "attrTag" // {
        type = { tags, ... }: lib.types.attrTag tags;
        payload = { inherit tags; };
        binOp =
          let
            # Add metadata in the format that submodules work with
            wrapOptionDecl = option: {
              options = option;
              _file = "<attrTag {...}>";
              pos = null;
            };
          in
          a: b: {
            tags =
              a.tags
              // b.tags
              // mapAttrs (
                tagName: bOpt:
                lib.mergeOptionDecls
                  # FIXME: loc is not accurate; should include prefix
                  #        Fortunately, it's only used for error messages, where a "relative" location is kinda ok.
                  #        It is also returned though, but use of the attribute seems rare?
                  [ tagName ]
                  [
                    (wrapOptionDecl a.tags.${tagName})
                    (wrapOptionDecl bOpt)
                  ]
                // {
                  # mergeOptionDecls is not idempotent in these attrs:
                  declarations = a.tags.${tagName}.declarations ++ bOpt.declarations;
                  declarationPositions = a.tags.${tagName}.declarationPositions ++ bOpt.declarationPositions;
                }
              ) (builtins.intersectAttrs a.tags b.tags);
          };
      };
    };

  /**
    A string wrapped using `lib.mkLuaInline`. Allows embedding lua expressions
    inline within generated lua. Multiple definitions cannot be merged.
  */
  luaInline = mkOptionType {
    name = "luaInline";
    description = "inline lua";
    descriptionClass = "noun";
    check = x: x._type or null == "lua-inline";
    merge = mergeEqualOption;
  };

  /**
    `types.uniq` *`t`*

    Ensures that type *`t`* cannot be merged. It is used to ensure option
    definitions are provided only once.
  */
  uniq = unique { message = ""; };

  /**
    `types.unique` `{ message = m }` *`t`*

    Ensures that type *`t`* cannot be merged. Prints the message *`m`*, after
    the line `The option <option path> is defined multiple times.` and before
    a list of definition locations.
  */
  unique =
    { message }:
    type:
    mkOptionType rec {
      name = "unique";
      inherit (type) description descriptionClass check;
      merge = mergeUniqueOption {
        inherit message;
        inherit (type) merge;
      };
      emptyValue = type.emptyValue;
      getSubOptions = type.getSubOptions;
      getSubModules = type.getSubModules;
      substSubModules = m: uniq (type.substSubModules m);
      functor = elemTypeFunctor name { elemType = type; } // {
        type = payload: lib.types.unique { inherit message; } payload.elemType;
      };
      nestedTypes.elemType = type;
    };

  /**
    `types.nullOr` *`t`*

    `null` or type *`t`*. Multiple definitions are merged according to
    type *`t`*.

    This is mostly equivalent to `either (enum [ null ]) t`, but `nullOr` provides a `null` fallback for attribute values with `mkIf false` definitions in `lazyAttrsOf (nullOr t)`, whereas `either` would throw an error when the attribute is accessed.
  */
  nullOr =
    elemType:
    mkOptionType rec {
      name = "nullOr";
      description = "null or ${
        optionDescriptionPhrase (class: class == "noun" || class == "conjunction") elemType
      }";
      descriptionClass = "conjunction";
      check = {
        __functor = _self: x: x == null || elemType.check x;
        isV2MergeCoherent = true;
      };
      merge = {
        __functor =
          self: loc: defs:
          let
            inherit (self.v2 { inherit loc defs; }) headError value;
          in
          if headError.causedByMixedNulls or false then throw headError.message else value;
        v2 =
          { loc, defs }:
          if all (def: def.value != null) defs then
            # There are no null values
            if elemType.merge ? v2 then
              checkV2MergeCoherence loc elemType (elemType.merge.v2 { inherit loc defs; })
            else
              {
                value = elemType.merge loc defs;
                headError = checkDefsForError elemType.check loc defs;
                valueMeta = { };
              }
          else
            # There are some null values
            {
              headError =
                if length defs == 1 || all (def: def.value == null) defs then
                  null
                else
                  {
                    message = "The option `${showOption loc}` is defined both null and not null, in ${showFiles (getFiles defs)}.";
                    causedByMixedNulls = true;
                  };
              value = null;
              valueMeta = { };
            };
      };
      emptyValue = {
        value = null;
      };
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: nullOr (elemType.substSubModules m);
      functor = (elemTypeFunctor name { inherit elemType; }) // {
        type = payload: lib.types.nullOr payload.elemType;
      };
      nestedTypes.elemType = elemType;
    };

  functionTo =
    elemType:
    mkOptionType {
      name = "functionTo";
      description = "function that evaluates to a(n) ${
        optionDescriptionPhrase (class: class == "noun" || class == "composite") elemType
      }";
      descriptionClass = "composite";
      check = isFunction;
      merge = loc: defs: {
        # An argument attribute has a default when it has a default in all definitions
        __functionArgs = zipAttrsWith (_: all (x: x)) (map (fn: functionArgs fn.value) defs);
        __functor =
          _: callerArgs:
          (mergeDefinitions (loc ++ [ "<function body>" ]) elemType (
            map (fn: {
              inherit (fn) file;
              value = fn.value callerArgs;
            }) defs
          )).mergedValue;
      };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ [ "<function body>" ]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: functionTo (elemType.substSubModules m);
      functor = (elemTypeFunctor "functionTo" { inherit elemType; }) // {
        type = payload: lib.types.functionTo payload.elemType;
      };
      nestedTypes.elemType = elemType;
    };

  /**
    `types.submodule` *`o`*

    A set of sub options *`o`*. *`o`* can be an attribute set, a function
    returning an attribute set, or a path to a file containing such a
    value. Submodules are used in composed types to create modular
    options. This is equivalent to
    `types.submoduleWith { modules = toList o; shorthandOnlyDefinesConfig = true; }`.

    `submodule` is a very powerful type that defines a set of sub-options
    that are handled like a separate module.

    It takes a parameter *`o`*, that should be a set, or a function returning
    a set with an `options` key defining the sub-options. Submodule option
    definitions are type-checked accordingly to the `options` declarations.
    Of course, you can nest submodule option definitions for even higher
    modularity.

    The option set can be defined directly
    ([Example: Directly defined submodule](#ex-submodule-direct)) or as reference
    ([Example: Submodule defined as a reference](#ex-submodule-reference)).

    Note that even if your submodule’s options all have a default value,
    you will still need to provide a default value (e.g. an empty attribute set)
    if you want to allow users to leave it undefined.

    ::: {#ex-submodule-direct .example}
    # Directly defined submodule
    ```nix
    {
      options.mod = mkOption {
        description = "submodule example";
        type =
          with types;
          submodule {
            options = {
              foo = mkOption { type = int; };
              bar = mkOption { type = str; };
            };
          };
      };
    }
    ```
    :::

    ::: {#ex-submodule-reference .example}
    # Submodule defined as a reference
    ```nix
    let
      modOptions = {
        options = {
          foo = mkOption { type = int; };
          bar = mkOption { type = int; };
        };
      };
    in
    {
      options.mod = mkOption {
        description = "submodule example";
        type = with types; submodule modOptions;
      };
    }
    ```
    :::

    The `submodule` type is especially interesting when used with composed
    types like `attrsOf` or `listOf`. When composed with `listOf`
    ([Example: Declaration of a list of submodules](#ex-submodule-listof-declaration)), `submodule` allows
    multiple definitions of the submodule option set
    ([Example: Definition of a list of submodules](#ex-submodule-listof-definition)).

    ::: {#ex-submodule-listof-declaration .example}
    # Declaration of a list of submodules
    ```nix
    {
      options.mod = mkOption {
        description = "submodule example";
        type =
          with types;
          listOf (submodule {
            options = {
              foo = mkOption { type = int; };
              bar = mkOption { type = str; };
            };
          });
      };
    }
    ```
    :::

    ::: {#ex-submodule-listof-definition .example}
    # Definition of a list of submodules
    ```nix
    {
      config.mod = [
        {
          foo = 1;
          bar = "one";
        }
        {
          foo = 2;
          bar = "two";
        }
      ];
    }
    ```
    :::

    When composed with `attrsOf`
    ([Example: Declaration of attribute sets of submodules](#ex-submodule-attrsof-declaration)), `submodule` allows
    multiple named definitions of the submodule option set
    ([Example: Definition of attribute sets of submodules](#ex-submodule-attrsof-definition)).

    ::: {#ex-submodule-attrsof-declaration .example}
    # Declaration of attribute sets of submodules
    ```nix
    {
      options.mod = mkOption {
        description = "submodule example";
        type =
          with types;
          attrsOf (submodule {
            options = {
              foo = mkOption { type = int; };
              bar = mkOption { type = str; };
            };
          });
      };
    }
    ```
    :::

    ::: {#ex-submodule-attrsof-definition .example}
    # Definition of attribute sets of submodules
    ```nix
    {
      config.mod.one = {
        foo = 1;
        bar = "one";
      };
      config.mod.two = {
        foo = 2;
        bar = "two";
      };
    }
    ```
    :::
  */
  submodule =
    modules:
    submoduleWith {
      shorthandOnlyDefinesConfig = true;
      modules = toList modules;
    };

  /**
    Whereas `submodule` represents an option tree, `deferredModule` represents
    a module value, such as a module file or a configuration.

    It can be set multiple times.

    Module authors can use its value in `imports`, in `submoduleWith`'s `modules`
    or in `evalModules`' `modules` parameter, among other places.

    Note that `imports` must be evaluated before the module fixpoint. Because
    of this, deferred modules can only be imported into "other" fixpoints, such
    as submodules.

    One use case for this type is the type of a "default" module that allow the
    user to affect all submodules in an `attrsOf submodule` at once. This is
    more convenient and discoverable than expecting the module user to
    type-merge with the `attrsOf submodule` option.
  */
  deferredModule = deferredModuleWith { };

  # A module to be imported in some other part of the configuration.
  # `staticModules`' options will be added to the documentation, unlike
  # options declared via `config`.
  deferredModuleWith =
    attrs@{
      staticModules ? [ ],
    }:
    mkOptionType {
      name = "deferredModule";
      description = "module";
      descriptionClass = "noun";
      check = x: isAttrs x || isFunction x || path.check x;
      merge = loc: defs: {
        imports =
          staticModules
          ++ map (
            def: lib.setDefaultModuleLocation "${def.file}, via option ${showOption loc}" def.value
          ) defs;
      };
      inherit (submoduleWith { modules = staticModules; })
        getSubOptions
        getSubModules
        ;
      substSubModules =
        m:
        deferredModuleWith (
          attrs
          // {
            staticModules = m;
          }
        );
      functor = defaultFunctor "deferredModuleWith" // {
        type = lib.types.deferredModuleWith;
        payload = {
          inherit staticModules;
        };
        binOp = lhs: rhs: {
          staticModules = lhs.staticModules ++ rhs.staticModules;
        };
      };
    };

  /**
    The type of a module system option declaration, as created by `lib.mkOption`.
    This allows an option to hold another option declaration as its value, which
    can then be spliced into a module's `options` attrset. Note that this only
    accepts option declarations, not evaluated options (i.e. options that have
    been processed by `evalModules` and have a `value` field).

    ::: {.warning}
    Use of this type is a form of metaprogramming that makes modules harder
    to reason about, since options and their types become dynamic values
    rather than statically declared structure. Prefer conventional module
    patterns where possible, and only reach for `types.optionDeclaration` when the
    added complexity is justified.
    :::
  */
  optionDeclaration = mkOptionType {
    name = "optionDeclaration";
    description = "option declaration";
    descriptionClass = "noun";
    check = opt: isType "option" opt && !(opt ? value);
  };

  /**
    The type of an option's type. Its merging operation ensures that nested
    options have the correct file location annotated, and that if possible,
    multiple option definitions are correctly merged together. The main use
    case is as the type of the `_module.freeformType` option.
  */
  optionType = mkOptionType {
    name = "optionType";
    description = "optionType";
    descriptionClass = "noun";
    check = isType "option-type";
    merge =
      loc: defs:
      if length defs == 1 then
        (head defs).value
      else
        let
          # Prepares the type definitions for mergeOptionDecls, which
          # annotates submodules types with file locations
          optionModules = map (
            { value, file }:
            {
              _file = file;
              # There's no way to merge types directly from the module system,
              # but we can cheat a bit by just declaring an option with the type
              options = lib.mkOption {
                type = value;
              };
            }
          ) defs;
          # Merges all the types into a single one, including submodule merging.
          # This also propagates file information to all submodules
          mergedOption = fixupOptionType loc (mergeOptionDecls loc optionModules);
        in
        mergedOption.type;
  };

  /**
    `types.submoduleWith` { *`modules`*, *`specialArgs`* ? {}, *`shorthandOnlyDefinesConfig`* ? false }

    Like `types.submodule`, but more flexible and with better defaults.
    It has parameters

    -   *`modules`* A list of modules to use by default for this
        submodule type. This gets combined with all option definitions
        to build the final list of modules that will be included.

        ::: {.note}
        Only options defined with this argument are included in rendered
        documentation.
        :::

    -   *`specialArgs`* An attribute set of extra arguments to be passed
        to the module functions. The option `_module.args` should be
        used instead for most arguments since it allows overriding.
        *`specialArgs`* should only be used for arguments that can't go
        through the module fixed-point, because of infinite recursion or
        other problems. An example is overriding the `lib` argument,
        because `lib` itself is used to define `_module.args`, which
        makes using `_module.args` to define it impossible.

    -   *`shorthandOnlyDefinesConfig`* Whether definitions of this type
        should default to the `config` section of a module (see
        [Example: Structure of NixOS Modules](https://nixos.org/manual/nixos/unstable/#ex-module-syntax))
        if it is an attribute set. Enabling this only has a benefit
        when the submodule defines an option named `config` or `options`.
        In such a case it would allow the option to be set with
        `the-submodule.config = "value"` instead of requiring
        `the-submodule.config.config = "value"`. This is because
        only when modules *don't* set the `config` or `options`
        keys, all keys are interpreted as option definitions in the
        `config` section. Enabling this option implicitly puts all
        attributes in the `config` section.

        With this option enabled, defining a non-`config` section
        requires using a function:
        `the-submodule = { ... }: { options = { ... }; }`.
  */
  submoduleWith =
    {
      modules,
      specialArgs ? { },
      shorthandOnlyDefinesConfig ? false,
      description ? null,
      class ? null,
    }@attrs:
    let
      inherit (lib.modules) evalModules;

      allModules =
        defs:
        map (
          { value, file }:
          if isAttrs value && shorthandOnlyDefinesConfig then
            {
              _file = file;
              config = value;
            }
          else
            {
              _file = file;
              imports = [ value ];
            }
        ) defs;

      base = evalModules {
        inherit class specialArgs;
        modules = [
          {
            # This is a work-around for the fact that some sub-modules,
            # such as the one included in an attribute set, expects an "args"
            # attribute to be given to the sub-module. As the option
            # evaluation does not have any specific attribute name yet, we
            # provide a default for the documentation and the freeform type.
            #
            # This is necessary as some option declaration might use the
            # "name" attribute given as argument of the submodule and use it
            # as the default of option declarations.
            #
            # We use lookalike unicode single angle quotation marks because
            # of the docbook transformation the options receive. In all uses
            # &gt; and &lt; wouldn't be encoded correctly so the encoded values
            # would be used, and use of `<` and `>` would break the XML document.
            # It shouldn't cause an issue since this is cosmetic for the manual.
            _module.args.name = lib.mkOptionDefault "‹name›";
          }
        ]
        ++ modules;
      };

      freeformType = base._module.freeformType;

      name = "submodule";

      check = {
        __functor = _self: x: isAttrs x || isFunction x || path.check x;
        isV2MergeCoherent = true;
      };
    in
    mkOptionType {
      inherit name;
      description =
        if description != null then
          description
        else
          let
            docsEval = base.extendModules { modules = [ noCheckForDocsModule ]; };
          in
          if docsEval._module.freeformType ? description then
            "open ${name} of ${
              optionDescriptionPhrase (
                class: class == "noun" || class == "composite"
              ) docsEval._module.freeformType
            }"
          else
            name;
      inherit check;
      merge = {
        __functor =
          self: loc: defs:
          (self.v2 { inherit loc defs; }).value;
        v2 =
          { loc, defs }:
          let
            configuration = base.extendModules {
              modules = [ { _module.args.name = last loc; } ] ++ allModules defs;
              prefix = loc;
            };
          in
          {
            headError = checkDefsForError check loc defs;
            value = configuration.config;
            valueMeta = { inherit configuration; };
          };
      };
      emptyValue = {
        value = base.config;
      };
      getSubOptions =
        prefix:
        let
          docsEval = (
            base.extendModules {
              inherit prefix;
              modules = [ noCheckForDocsModule ];
            }
          );
          # Intentionally shadow the freeformType from the possibly *checked*
          # configuration. See `noCheckForDocsModule` comment.
          inherit (docsEval._module) freeformType;
        in
        docsEval.options
        // optionalAttrs (freeformType != null) {
          # Expose the sub options of the freeform type. Note that the option
          # discovery doesn't care about the attribute name used here, so this
          # is just to avoid conflicts with potential options from the submodule
          _freeformOptions = freeformType.getSubOptions prefix;
        };
      getSubModules = modules;
      substSubModules =
        m:
        submoduleWith (
          attrs
          // {
            modules = m;
          }
        );
      nestedTypes = lib.optionalAttrs (freeformType != null) {
        freeformType = freeformType;
      };
      functor = defaultFunctor name // {
        type = lib.types.submoduleWith;
        payload = {
          inherit
            modules
            class
            specialArgs
            shorthandOnlyDefinesConfig
            description
            ;
        };
        binOp = lhs: rhs: {
          class =
            # `or null` was added for backwards compatibility only. `class` is
            # always set in the current version of the module system.
            if lhs.class or null == null then
              rhs.class or null
            else if rhs.class or null == null then
              lhs.class or null
            else if lhs.class or null == rhs.class then
              lhs.class or null
            else
              throw "A submoduleWith option is declared multiple times with conflicting class values \"${toString lhs.class}\" and \"${toString rhs.class}\".";
          modules = lhs.modules ++ rhs.modules;
          specialArgs =
            let
              intersecting = builtins.intersectAttrs lhs.specialArgs rhs.specialArgs;
            in
            if intersecting == { } then
              lhs.specialArgs // rhs.specialArgs
            else
              throw "A submoduleWith option is declared multiple times with the same specialArgs \"${toString (attrNames intersecting)}\"";
          shorthandOnlyDefinesConfig =
            if lhs.shorthandOnlyDefinesConfig == null then
              rhs.shorthandOnlyDefinesConfig
            else if rhs.shorthandOnlyDefinesConfig == null then
              lhs.shorthandOnlyDefinesConfig
            else if lhs.shorthandOnlyDefinesConfig == rhs.shorthandOnlyDefinesConfig then
              lhs.shorthandOnlyDefinesConfig
            else
              throw "A submoduleWith option is declared multiple times with conflicting shorthandOnlyDefinesConfig values";
          description =
            if lhs.description == null then
              rhs.description
            else if rhs.description == null then
              lhs.description
            else if lhs.description == rhs.description then
              lhs.description
            else
              throw "A submoduleWith option is declared multiple times with conflicting descriptions";
        };
      };
    };

  /**
    `types.enum` *`l`*

    One element of the list *`l`*, e.g. `types.enum [ "left" "right" ]`.
    Multiple definitions cannot be merged.

    If you want to pair these values with more information, possibly of
    distinct types, consider using a [sum type](#function-library-lib.types.attrTag).
  */
  enum =
    values:
    let
      inherit (lib.lists) unique;
      show =
        v:
        if builtins.isString v then
          ''"${v}"''
        else if builtins.isInt v then
          toString v
        else if builtins.isBool v then
          boolToString v
        else
          "<${builtins.typeOf v}>";
    in
    mkOptionType rec {
      name = "enum";
      description =
        # Length 0 or 1 enums may occur in a design pattern with type merging
        # where an "interface" module declares an empty enum and other modules
        # provide implementations, each extending the enum with their own
        # identifier.
        if values == [ ] then
          "impossible (empty enum)"
        else if builtins.length values == 1 then
          "value ${show (builtins.head values)} (singular enum)"
        else
          "one of ${concatMapStringsSep ", " show values}";
      descriptionClass = if builtins.length values < 2 then "noun" else "conjunction";
      check = flip elem values;
      merge = mergeEqualOption;
      functor = (defaultFunctor name) // {
        payload = { inherit values; };
        type = payload: lib.types.enum payload.values;
        binOp = a: b: { values = unique (a.values ++ b.values); };
      };
    };

  /**
    Creates a value type suitable for serialization formats.

    Parameters:
    - typeName: String describing the format (e.g. "JSON", "YAML", "XML")
    - nullable: Whether the structured value type allows `null` values.

    Returns a type suitable for structured data formats that supports:
    - Basic types: boolean, integer, float, string, path
    - Complex types: attribute sets and lists
  */
  serializableValueWith =
    {
      typeName,
      nullable ? true,
    }:
    let
      baseType = oneOf [
        bool
        int
        float
        str
        path
        (attrsOf valueType)
        (listOf valueType)
      ];
      valueType = (if nullable then nullOr baseType else baseType) // {
        description = "${typeName} value";
      };
    in
    valueType;

  /**
    A type representing JSON-compatible values. This includes `null`, booleans,
    integers, floats, strings, paths, attribute sets, and lists.
    Attribute sets and lists can be arbitrarily nested and contain any JSON-compatible
    values.
  */
  json = serializableValueWith { typeName = "JSON"; };

  /**
    A type representing TOML-compatible values. This includes booleans,
    integers, floats, strings, paths, attribute sets, and lists.
    Attribute sets and lists can be arbitrarily nested and contain any TOML-compatible
    values.
  */
  toml = serializableValueWith {
    typeName = "TOML";
    nullable = false;
  };

  /**
    <!-- SYNC WITH oneOf BELOW -->

    `types.either` *`t1 t2`*

    Type *`t1`* or type *`t2`*, e.g. `with types; either int str`.
    Multiple definitions cannot be merged.

    ::: {.warning}
    `either` and `oneOf` eagerly decide the active type based on the passed types' shallow check method. For composite types like `attrsOf` and `submodule`, which both match all attribute set definitions, the first type argument will be chosen for the returned option value, and this therefore also decides how nested values are checked and merged. For example, `either (attrsOf int) (submodule {...})` will always use `attrsOf int` for any attribute set value, even if it was intended as a submodule. This behavior is a trade-off that keeps the implementation simple and the evaluation order predictable, avoiding unexpected strictness problems such as infinite recursions. When proper type discrimination is needed, consider using a [sum type](#function-library-lib.types.attrTag) like `attrTag` instead.
    :::
  */
  either =
    t1: t2:
    mkOptionType rec {
      name = "either";
      description =
        if t1.descriptionClass or null == "nonRestrictiveClause" then
          # Plain, but add comma
          "${t1.description}, or ${
            optionDescriptionPhrase (class: class == "noun" || class == "conjunction") t2
          }"
        else
          "${optionDescriptionPhrase (class: class == "noun" || class == "conjunction") t1} or ${
            optionDescriptionPhrase (
              class: class == "noun" || class == "conjunction" || class == "composite"
            ) t2
          }";
      descriptionClass = "conjunction";
      check = {
        __functor = _self: x: t1.check x || t2.check x;
        isV2MergeCoherent = true;
      };
      merge = {
        __functor =
          self: loc: defs:
          (self.v2 { inherit loc defs; }).value;
        v2 =
          { loc, defs }@args:
          let
            t1CheckedAndMerged =
              if t1.merge ? v2 then
                checkV2MergeCoherence loc t1 (t1.merge.v2 args)
              else
                {
                  value = t1.merge loc defs;
                  headError = checkDefsForError t1.check loc defs;
                  valueMeta = { };
                };
            t2CheckedAndMerged =
              if t2.merge ? v2 then
                checkV2MergeCoherence loc t2 (t2.merge.v2 args)
              else
                {
                  value = t2.merge loc defs;
                  headError = checkDefsForError t2.check loc defs;
                  valueMeta = { };
                };

            checkedAndMerged =
              if t1CheckedAndMerged.headError == null then
                t1CheckedAndMerged
              else if t2CheckedAndMerged.headError == null then
                t2CheckedAndMerged
              else
                rec {
                  valueMeta = {
                    inherit headError;
                  };
                  headError = {
                    message = "The option `${showOption loc}` is neither a value of type `${t1.description}` nor `${t2.description}`, Definition values: ${showDefs defs}";
                  };
                  value = lib.warn ''
                    One or more definitions did not pass the type-check of the 'either' type.
                    ${headError.message}
                    If `either`, `oneOf` or similar is used in freeformType, ensure that it is preceded by an 'attrsOf' such as: `freeformType = types.attrsOf (types.either t1 t2)`.
                    Otherwise consider using the correct type for the option `${showOption loc}`.  This will be an error in Nixpkgs 26.05.
                  '' (mergeOneOption loc defs);
                };
          in
          checkedAndMerged;
      };
      typeMerge =
        f':
        let
          mt1 = t1.typeMerge (head f'.payload.elemType).functor;
          mt2 = t2.typeMerge (elemAt f'.payload.elemType 1).functor;
        in
        if (name == f'.name) && (mt1 != null) && (mt2 != null) then functor.type mt1 mt2 else null;
      functor = elemTypeFunctor name {
        elemType = [
          t1
          t2
        ];
      };
      nestedTypes.left = t1;
      nestedTypes.right = t2;
    };

  /**
    <!-- SYNC WITH either ABOVE -->

    `types.oneOf` \[ *`t1 t2`* ... \]

    Type *`t1`* or type *`t2`* and so forth, e.g.
    `with types; oneOf [ int str bool ]`. Multiple definitions cannot be
    merged.

    ::: {.warning}
    `either` and `oneOf` eagerly decide the active type based on the passed types' shallow check method. For composite types like `attrsOf` and `submodule`, which both match all attribute set definitions, the first matching type in the list will be chosen for the returned option value, and this therefore also decides how nested values are checked and merged. For example, `oneOf [ (attrsOf int) (submodule {...}) ]` will always use `attrsOf int` for any attribute set value, even if it was intended as a submodule. This behavior is a trade-off that keeps the implementation simple and the evaluation order predictable, avoiding unexpected strictness problems such as infinite recursions. When proper type discrimination is needed, consider using a [sum type](#function-library-lib.types.attrTag) like `attrTag` instead.
    :::
  */
  oneOf =
    ts:
    let
      head' =
        if ts == [ ] then throw "types.oneOf needs to get at least one type in its argument" else head ts;
    in
    foldl' either head' (tail ts);

  /**
    `types.coercedTo` *`from f to`*

    Type *`to`* or type *`from`* which will be coerced to type *`to`* using
    function *`f`* which takes an argument of type *`from`* and return a
    value of type *`to`*. Can be used to preserve backwards compatibility
    of an option if its type was changed.
  */
  coercedTo =
    coercedType: coerceFunc: finalType:
    assert
      coercedType.getSubModules == null
      || throw "coercedTo: coercedType must not have submodules (it’s a ${coercedType.description})";
    mkOptionType rec {
      name = "coercedTo";
      description = "${optionDescriptionPhrase (class: class == "noun") finalType} or ${
        optionDescriptionPhrase (class: class == "noun") coercedType
      } convertible to it";
      check = {
        __functor = _self: x: (coercedType.check x && finalType.check (coerceFunc x)) || finalType.check x;
        isV2MergeCoherent = true;
      };
      merge = {
        __functor =
          self: loc: defs:
          (self.v2 { inherit loc defs; }).value;
        v2 =
          { loc, defs }:
          let
            finalDefs = (
              map (
                def:
                def
                // {
                  value =
                    if coercedType.merge ? v2 then
                      let
                        merged = checkV2MergeCoherence loc coercedType (
                          coercedType.merge.v2 {
                            inherit loc;
                            defs = [ def ];
                          }
                        );
                      in
                      if merged.headError == null then coerceFunc def.value else def.value
                    else if coercedType.check def.value then
                      coerceFunc def.value
                    else
                      def.value;
                }
              ) defs
            );
          in
          if finalType.merge ? v2 then
            checkV2MergeCoherence loc finalType (
              finalType.merge.v2 {
                inherit loc;
                defs = finalDefs;
              }
            )
          else
            {
              value = finalType.merge loc finalDefs;
              valueMeta = { };
              headError = checkDefsForError check loc defs;
            };
      };
      emptyValue = finalType.emptyValue;
      getSubOptions = finalType.getSubOptions;
      getSubModules = finalType.getSubModules;
      substSubModules = m: coercedTo coercedType coerceFunc (finalType.substSubModules m);
      typeMerge = t: null;
      functor = defaultFunctor name;
      nestedTypes.coercedType = coercedType;
      nestedTypes.finalType = finalType;
    };

  /**
    Augment the given type with an additional type check function.

    :::{.warning}
    This function has some broken behavior see: [#396021](https://github.com/NixOS/nixpkgs/issues/396021)
    Fixing is not trivial, we appreciate any help!
    :::

    ::: {.example}
    # Adding a type check

    ```nix
    {
      byte = mkOption {
        description = "An integer between 0 and 255.";
        type = types.addCheck types.int (x: x >= 0 && x <= 255);
      };
    }
    ```
    :::
  */
  addCheck =
    elemType: check:
    if elemType.merge ? v2 then
      elemType
      // {
        check = {
          __functor = _self: x: elemType.check x && check x;
          isV2MergeCoherent = true;
        };
        merge = {
          __functor =
            self: loc: defs:
            (self.v2 { inherit loc defs; }).value;
          v2 =
            { loc, defs }@args:
            let
              orig = checkV2MergeCoherence loc elemType (elemType.merge.v2 args);
              headError' = if orig.headError != null then orig.headError else checkDefsForError check loc defs;
            in
            orig
            // {
              headError = headError';
            };
        };
      }
    else
      elemType
      // {
        check = x: elemType.check x && check x;
      };

  /**
    Merges two option types together.

    :::{.note}
    Uses the type merge function of the first type, to merge it with the second type.

    Usually types can only be merged if they are of the same type
    :::

    # Inputs

    : `a` (option type): The first option type.
    : `b` (option type): The second option type.

    # Returns

    - The merged option type.
    - `{ _type = "merge-error"; error = "Cannot merge types"; }` if the types can't be merged.

    # Examples
    :::{.example}
    ## `lib.types.mergeTypes` usage example
    ```nix
    let
      enumAB = lib.types.enum ["A" "B"];
      enumXY = lib.types.enum ["X" "Y"];
      # This operation could be notated as: [ A ] | [ B ] -> [ A B ]
      merged = lib.types.mergeTypes enumAB enumXY; # -> enum [ "A" "B" "X" "Y" ]
    in
      assert merged.check "A"; # true
      assert merged.check "B"; # true
      assert merged.check "X"; # true
      assert merged.check "Y"; # true
      merged.check "C" # false
    ```
    :::
  */
  mergeTypes =
    a: b:
    assert isOptionType a && isOptionType b;
    let
      merged = a.typeMerge b.functor;
    in
    if merged == null then setType "merge-error" { error = "Cannot merge types"; } else merged;

  # TODO: Migrate usage of lib.types.types in nixpkgs
  # Then add a deprecation warning
  types = lib.types;
}
