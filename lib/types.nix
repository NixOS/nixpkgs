# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.
{ lib }:

let
  inherit (lib)
    elem
    flip
    isAttrs
    isBool
    isDerivation
    isFloat
    isFunction
    isInt
    isList
    isString
    isStorePath
    throwIf
    toDerivation
    toList
    ;
  inherit (lib.lists)
    concatLists
    count
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
    ;
  inherit (lib.fileset)
    isFileset
    unions
    empty
    ;

  inAttrPosSuffix =
    v: name:
    let
      pos = builtins.unsafeGetAttrPos name v;
    in
    if pos == null then "" else " at ${pos.file}:${toString pos.line}:${toString pos.column}";

  # Internal functor to help for migrating functor.wrapped to functor.payload.elemType
  # Note that individual attributes can be overridden if needed.
  elemTypeFunctor =
    name:
    { elemType, ... }@payload:
    {
      inherit name payload;
      wrappedDeprecationMessage = makeWrappedDeprecationMessage payload;
      type = outer_types.types.${name};
      binOp =
        a: b:
        let
          merged = a.elemType.typeMerge b.elemType.functor;
        in
        if merged == null then null else { elemType = merged; };
    };
  makeWrappedDeprecationMessage =
    payload:
    { loc }:
    lib.warn ''
      The deprecated `${lib.optionalString (loc != null) "type."}functor.wrapped` attribute ${
        lib.optionalString (loc != null) "of the option `${showOption loc}` "
      }is accessed, use `${lib.optionalString (loc != null) "type."}nestedTypes.elemType` instead.
    '' payload.elemType;

  checkDefsForError =
    check: loc: defs:
    let
      invalidDefs = filter (def: !check def.value) defs;
    in
    if invalidDefs != [ ] then { message = "Definition values: ${showDefs invalidDefs}"; } else null;

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

  outer_types = rec {
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
        mergedWrapped = f.wrapped.typeMerge f'.wrapped.functor;
        mergedPayload = f.binOp f.payload f'.payload;

        hasPayload =
          assert (f'.payload != null) == (f.payload != null);
          f.payload != null;
        hasWrapped =
          assert (f'.wrapped != null) == (f.wrapped != null);
          f.wrapped != null;

        typeFromPayload = if mergedPayload == null then null else f.type mergedPayload;
        typeFromWrapped = if mergedWrapped == null then null else f.type mergedWrapped;
      in
      # Abort early: cannot merge different types
      if f.name != f'.name then
        null
      else

      if hasPayload then
        # Just return the payload if returning wrapped is deprecated
        if f ? wrappedDeprecationMessage then
          typeFromPayload
        else if hasWrapped then
          # Has both wrapped and payload
          throw ''
            Type ${f.name} defines both `functor.payload` and `functor.wrapped` at the same time, which is not supported.

            Use either `functor.payload` or `functor.wrapped` but not both.

            If your code worked before remove either `functor.wrapped` or `functor.payload` from the type definition.
          ''
        else
          typeFromPayload
      else if hasWrapped then
        typeFromWrapped
      else
        f.type;

    # Default type functor
    defaultFunctor = name: {
      inherit name;
      type = types.${name} or null;
      wrapped = null;
      payload = null;
      binOp = a: b: null;
    };

    isOptionType = isType "option-type";
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
          ;
        functor =
          if functor ? wrappedDeprecationMessage then
            functor
            // {
              wrapped = functor.wrappedDeprecationMessage {
                loc = null;
              };
            }
          else
            functor;
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

    # When adding new types don't forget to document them in
    # nixos/doc/manual/development/option-types.section.md!
    types = rec {

      raw = mkOptionType {
        name = "raw";
        description = "raw value";
        descriptionClass = "noun";
        check = value: true;
        merge = mergeOneOption;
      };

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

      bool = mkOptionType {
        name = "bool";
        description = "boolean";
        descriptionClass = "noun";
        check = isBool;
        merge = mergeEqualOption;
      };

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

      int = mkOptionType {
        name = "int";
        description = "signed integer";
        descriptionClass = "noun";
        check = isInt;
        merge = mergeEqualOption;
      };

      # Specialized subdomains of int
      ints =
        let
          betweenDesc = lowest: highest: "${toString lowest} and ${toString highest} (both inclusive)";
          between =
            lowest: highest:
            assert lib.assertMsg (lowest <= highest) "ints.between: lowest must be smaller than highest";
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
          # TODO: Deduplicate with docs in nixos/doc/manual/development/option-types.section.md
          /**
            An int with a fixed range.

            # Example
            :::{.example}
            ## `lib.types.ints.between` usage example

            ```nix
            (ints.between 0 100).check (-1)
            => false
            (ints.between 0 100).check (101)
            => false
            (ints.between 0 0).check 0
            => true
            ```

            :::
          */
          inherit between;

          unsigned = addCheck types.int (x: x >= 0) // {
            name = "unsignedInt";
            description = "unsigned integer, meaning >=0";
            descriptionClass = "nonRestrictiveClause";
          };
          positive = addCheck types.int (x: x > 0) // {
            name = "positiveInt";
            description = "positive integer, meaning >0";
            descriptionClass = "nonRestrictiveClause";
          };
          u8 = unsign 8 256;
          u16 = unsign 16 65536;
          # the biggest int Nix accepts is 2^63 - 1 (9223372036854775808)
          # the smallest int Nix accepts is -2^63 (-9223372036854775807)
          u32 = unsign 32 4294967296;
          # u64 = unsign 64 18446744073709551616;

          s8 = sign 8 256;
          s16 = sign 16 65536;
          s32 = sign 32 4294967296;
        };

      # Alias of u16 for a port number
      port = ints.u16;

      float = mkOptionType {
        name = "float";
        description = "floating point number";
        descriptionClass = "noun";
        check = isFloat;
        merge = mergeEqualOption;
      };

      number = either int float;

      numbers =
        let
          betweenDesc =
            lowest: highest: "${builtins.toJSON lowest} and ${builtins.toJSON highest} (both inclusive)";
        in
        {
          between =
            lowest: highest:
            assert lib.assertMsg (lowest <= highest) "numbers.between: lowest must be smaller than highest";
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
        in
        mkOptionType {
          name = "singleLineStr";
          description = "(optionally newline-terminated) single-line string";
          descriptionClass = "noun";
          inherit check;
          merge = loc: defs: lib.removeSuffix "\n" (merge loc defs);
        };

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

      # Merge multiple definitions by concatenating them (with the given
      # separator between the values).
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
            type = payload: types.separatedString payload.sep;
            binOp = lhs: rhs: if lhs.sep == rhs.sep then { inherit (lhs) sep; } else null;
          };
        };

      lines = separatedString "\n";
      commas = separatedString ",";
      envVar = separatedString ":";

      passwdEntry =
        entryType:
        addCheck entryType (str: !(hasInfix ":" str || hasInfix "\n" str))
        // {
          name = "passwdEntry ${entryType.name}";
          description = "${
            optionDescriptionPhrase (class: class == "noun") entryType
          }, not containing newlines or colons";
          descriptionClass = "nonRestrictiveClause";
        };

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
        merge = loc: defs: unions (map (x: x.value) defs);
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
      package = mkOptionType {
        name = "package";
        descriptionClass = "noun";
        check = x: isDerivation x || isStorePath x;
        merge =
          loc: defs:
          let
            res = mergeOneOption loc defs;
          in
          if builtins.isPath res || (builtins.isString res && !builtins.hasContext res) then
            toDerivation res
          else
            res;
      };

      shellPackage = package // {
        check = x: isDerivation x && hasAttr "shellPath" x;
      };

      pkgs = addCheck (
        unique { message = "A Nixpkgs pkgs set can not be merged with another pkgs set."; } attrs
        // {
          name = "pkgs";
          descriptionClass = "noun";
          description = "Nixpkgs package set";
        }
      ) (x: (x._type or null) == "pkgs");

      path = pathWith {
        absolute = true;
      };

      pathInStore = pathWith {
        inStore = true;
      };

      externalPath = pathWith {
        absolute = true;
        inStore = false;
      };

      pathWith =
        {
          inStore ? null,
          absolute ? null,
        }:
        throwIf (inStore != null && absolute != null && inStore && !absolute)
          "In pathWith, inStore means the path must be absolute"
          mkOptionType
          {
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
                isInStore = lib.path.hasStorePathPrefix (
                  if builtins.isPath x then
                    x
                  # Discarding string context is necessary to convert the value to
                  # a path and safe as the result is never used in any derivation.
                  else
                    /. + builtins.unsafeDiscardStringContext x
                );
                isAbsolute = builtins.substring 0 1 (toString x) == "/";
                isExpectedType = (
                  if inStore == null || inStore then isStringLike x else isString x # Do not allow a true path, which could be copied to the store later on.
                );
              in
              isExpectedType
              && (inStore == null || inStore == isInStore)
              && (absolute == null || absolute == isAbsolute);
          };

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
            type = payload: types.listOf payload.elemType;
          };
          nestedTypes.elemType = elemType;
        };

      nonEmptyListOf =
        elemType:
        let
          list = addCheck (types.listOf elemType) (l: l != [ ]);
        in
        list
        // {
          description = "non-empty ${optionDescriptionPhrase (class: class == "noun") list}";
          emptyValue = { }; # no .value attr, meaning unset
          substSubModules = m: nonEmptyListOf (elemType.substSubModules m);
        };

      attrsOf = elemType: attrsWith { inherit elemType; };

      # A version of attrsOf that's lazy in its values at the expense of
      # conditional definitions not working properly. E.g. defining a value with
      # `foo.attr = mkIf false 10`, then `foo ? attr == true`, whereas with
      # attrsOf it would correctly be `false`. Accessing `foo.attr` would throw an
      # error that it's not defined. Use only if conditional definitions don't make sense.
      lazyAttrsOf =
        elemType:
        attrsWith {
          inherit elemType;
          lazy = true;
        };

      # base type for lazyAttrsOf and attrsOf
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
        types.attrsOf elemType
        // {
          name = "loaOf";
          deprecationMessage =
            "Mixing lists with attribute values is no longer"
            + " possible; please use `types.attrsOf` instead. See"
            + " https://github.com/NixOS/nixpkgs/issues/1800 for the motivation.";
          nestedTypes.elemType = elemType;
        };

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
                throwIf (opt._type or null != "option")
                  "In attrTag, each tag value must be an option, but tag ${lib.strings.escapeNixIdentifier n} ${
                    if opt ? _type then
                      if opt._type == "option-type" then
                        "was a bare type, not wrapped in mkOption."
                      else
                        "was of type ${lib.strings.escapeNixString opt._type}."
                    else
                      "was not."
                  }"
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
          functor = defaultFunctor "attrTag" // {
            type = { tags, ... }: types.attrTag tags;
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

      # A value produced by `lib.mkLuaInline`
      luaInline = mkOptionType {
        name = "luaInline";
        description = "inline lua";
        descriptionClass = "noun";
        check = x: x._type or null == "lua-inline";
        merge = mergeEqualOption;
      };

      uniq = unique { message = ""; };

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
            type = payload: types.unique { inherit message; } payload.elemType;
          };
          nestedTypes.elemType = type;
        };

      # Null or value of ...
      nullOr =
        elemType:
        mkOptionType rec {
          name = "nullOr";
          description = "null or ${
            optionDescriptionPhrase (class: class == "noun" || class == "conjunction") elemType
          }";
          descriptionClass = "conjunction";
          check = x: x == null || elemType.check x;
          merge =
            loc: defs:
            let
              nrNulls = count (def: def.value == null) defs;
            in
            if nrNulls == length defs then
              null
            else if nrNulls != 0 then
              throw "The option `${showOption loc}` is defined both null and not null, in ${showFiles (getFiles defs)}."
            else
              elemType.merge loc defs;
          emptyValue = {
            value = null;
          };
          getSubOptions = elemType.getSubOptions;
          getSubModules = elemType.getSubModules;
          substSubModules = m: nullOr (elemType.substSubModules m);
          functor = (elemTypeFunctor name { inherit elemType; }) // {
            type = payload: types.nullOr payload.elemType;
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
            __functionArgs = lib.zipAttrsWith (_: lib.all (x: x)) (
              lib.map (fn: lib.functionArgs fn.value) defs
            );
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
            type = payload: types.functionTo payload.elemType;
          };
          nestedTypes.elemType = elemType;
        };

      # A submodule (like typed attribute set). See NixOS manual.
      submodule =
        modules:
        submoduleWith {
          shorthandOnlyDefinesConfig = true;
          modules = toList modules;
        };

      # A module to be imported in some other part of the configuration.
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
            type = types.deferredModuleWith;
            payload = {
              inherit staticModules;
            };
            binOp = lhs: rhs: {
              staticModules = lhs.staticModules ++ rhs.staticModules;
            };
          };
        };

      # The type of a type!
      optionType = mkOptionType {
        name = "optionType";
        description = "optionType";
        descriptionClass = "noun";
        check = value: value._type or null == "option-type";
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
            value = { };
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
            type = types.submoduleWith;
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

      # A value from a set of allowed ones.
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
              ''<${builtins.typeOf v}>'';
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
            type = payload: types.enum payload.values;
            binOp = a: b: { values = unique (a.values ++ b.values); };
          };
        };

      # Either value of type `t1` or `t2`.
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
              { loc, defs }:
              let
                t1CheckedAndMerged =
                  if t1.merge ? v2 then
                    checkV2MergeCoherence loc t1 (t1.merge.v2 { inherit loc defs; })
                  else
                    {
                      value = t1.merge loc defs;
                      headError = checkDefsForError t1.check loc defs;
                      valueMeta = { };
                    };
                t2CheckedAndMerged =
                  if t2.merge ? v2 then
                    checkV2MergeCoherence loc t2 (t2.merge.v2 { inherit loc defs; })
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
              mt1 = t1.typeMerge (elemAt f'.payload.elemType 0).functor;
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

      # Any of the types in the given list
      oneOf =
        ts:
        let
          head' =
            if ts == [ ] then throw "types.oneOf needs to get at least one type in its argument" else head ts;
          tail' = tail ts;
        in
        foldl' either head' tail';

      # Either value of type `coercedType` or `finalType`, the former is
      # converted to `finalType` using `coerceFunc`.
      coercedTo =
        coercedType: coerceFunc: finalType:
        assert lib.assertMsg (
          coercedType.getSubModules == null
        ) "coercedTo: coercedType must not have submodules (it’s a ${coercedType.description})";
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
                        let
                          merged =
                            if coercedType.merge ? v2 then
                              checkV2MergeCoherence loc coercedType (
                                coercedType.merge.v2 {
                                  inherit loc;
                                  defs = [ def ];
                                }
                              )
                            else
                              null;
                        in
                        if coercedType.merge ? v2 then
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
          functor = (defaultFunctor name) // {
            wrappedDeprecationMessage = makeWrappedDeprecationMessage { elemType = finalType; };
          };
          nestedTypes.coercedType = coercedType;
          nestedTypes.finalType = finalType;
        };

      /**
        Augment the given type with an additional type check function.

        :::{.warning}
        This function has some broken behavior see: [#396021](https://github.com/NixOS/nixpkgs/issues/396021)
        Fixing is not trivial, we appreciate any help!
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
                { loc, defs }:
                let
                  orig = checkV2MergeCoherence loc elemType (elemType.merge.v2 { inherit loc defs; });
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
  };

in
outer_types // outer_types.types
