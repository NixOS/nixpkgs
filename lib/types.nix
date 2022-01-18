# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.
{ lib }:

let
  inherit (lib)
    elem
    flip
    functionArgs
    isAttrs
    isBool
    isDerivation
    isFloat
    isFunction
    isInt
    isList
    isString
    isStorePath
    setFunctionArgs
    toDerivation
    toList
    ;
  inherit (lib.lists)
    all
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
    unique
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
    showFiles
    showOption
    ;
  inherit (lib.strings)
    concatMapStringsSep
    concatStringsSep
    escapeNixString
    isCoercibleToString
    ;
  inherit (lib.trivial)
    boolToString
    ;

  inherit (lib.modules) mergeDefinitions;
  outer_types =
rec {
  isType = type: x: (x._type or "") == type;

  setType = typeName: value: value // {
    _type = typeName;
  };


  # Default type merging function
  # takes two type functors and return the merged type
  defaultTypeMerge = f: f':
    let wrapped = f.wrapped.typeMerge f'.wrapped.functor;
        payload = f.binOp f.payload f'.payload;
    in
    # cannot merge different types
    if f.name != f'.name
       then null
    # simple types
    else if    (f.wrapped == null && f'.wrapped == null)
            && (f.payload == null && f'.payload == null)
       then f.type
    # composed types
    else if (f.wrapped != null && f'.wrapped != null) && (wrapped != null)
       then f.type wrapped
    # value types
    else if (f.payload != null && f'.payload != null) && (payload != null)
       then f.type payload
    else null;

  # Default type functor
  defaultFunctor = name: {
    inherit name;
    type    = types.${name} or null;
    wrapped = null;
    payload = null;
    binOp   = a: b: null;
  };

  isOptionType = isType "option-type";
  mkOptionType =
    { # Human-readable representation of the type, should be equivalent to
      # the type function name.
      name
    , # Description of the type, defined recursively by embedding the wrapped type if any.
      description ? null
    , # Function applied to each definition that should return true if
      # its type-correct, false otherwise.
      check ? (x: true)
    , # Merge a list of definitions together into a single value.
      # This function is called with two arguments: the location of
      # the option in the configuration as a list of strings
      # (e.g. ["boot" "loader "grub" "enable"]), and a list of
      # definition values and locations (e.g. [ { file = "/foo.nix";
      # value = 1; } { file = "/bar.nix"; value = 2 } ]).
      merge ? mergeDefaultOption
    , # Whether this type has a value representing nothingness. If it does,
      # this should be a value of the form { value = <the nothing value>; }
      # If it doesn't, this should be {}
      # This may be used when a value is required for `mkIf false`. This allows the extra laziness in e.g. `lazyAttrsOf`.
      emptyValue ? {}
    , # Return a flat list of sub-options.  Used to generate
      # documentation.
      getSubOptions ? prefix: {}
    , # List of modules if any, or null if none.
      getSubModules ? null
    , # Function for building the same option type with a different list of
      # modules.
      substSubModules ? m: null
    , # Function that merge type declarations.
      # internal, takes a functor as argument and returns the merged type.
      # returning null means the type is not mergeable
      typeMerge ? defaultTypeMerge functor
    , # The type functor.
      # internal, representation of the type as an attribute set.
      #   name: name of the type
      #   type: type function.
      #   wrapped: the type wrapped in case of compound types.
      #   payload: values of the type, two payloads of the same type must be
      #            combinable with the binOp binary operation.
      #   binOp: binary operation that merge two payloads of the same type.
      functor ? defaultFunctor name
    , # The deprecation message to display when this type is used by an option
      # If null, the type isn't deprecated
      deprecationMessage ? null
    , # The types that occur in the definition of this type. This is used to
      # issue deprecation warnings recursively. Can also be used to reuse
      # nested types
      nestedTypes ? {}
    }:
    { _type = "option-type";
      inherit name check merge emptyValue getSubOptions getSubModules substSubModules typeMerge functor deprecationMessage nestedTypes;
      description = if description == null then name else description;
    };


  # When adding new types don't forget to document them in
  # nixos/doc/manual/development/option-types.xml!
  types = rec {

    anything = mkOptionType {
      name = "anything";
      description = "anything";
      check = value: true;
      merge = loc: defs:
        let
          getType = value:
            if isAttrs value && isCoercibleToString value
            then "stringCoercibleSet"
            else builtins.typeOf value;

          # Returns the common type of all definitions, throws an error if they
          # don't have the same type
          commonType = foldl' (type: def:
            if getType def.value == type
            then type
            else throw "The option `${showOption loc}' has conflicting option types in ${showFiles (getFiles defs)}"
          ) (getType (head defs).value) defs;

          mergeFunction = {
            # Recursively merge attribute sets
            set = (attrsOf anything).merge;
            # Safe and deterministic behavior for lists is to only accept one definition
            # listOf only used to apply mkIf and co.
            list =
              if length defs > 1
              then throw "The option `${showOption loc}' has conflicting definitions, in ${showFiles (getFiles defs)}."
              else (listOf anything).merge;
            # This is the type of packages, only accept a single definition
            stringCoercibleSet = mergeOneOption;
            lambda = loc: defs: arg: anything.merge
              (loc ++ [ "<function body>" ])
              (map (def: {
                file = def.file;
                value = def.value arg;
              }) defs);
            # Otherwise fall back to only allowing all equal definitions
          }.${commonType} or mergeEqualOption;
        in mergeFunction loc defs;
    };

    unspecified = mkOptionType {
      name = "unspecified";
    };

    bool = mkOptionType {
      name = "bool";
      description = "boolean";
      check = isBool;
      merge = mergeEqualOption;
    };

    int = mkOptionType {
        name = "int";
        description = "signed integer";
        check = isInt;
        merge = mergeEqualOption;
      };

    # Specialized subdomains of int
    ints =
      let
        betweenDesc = lowest: highest:
          "${toString lowest} and ${toString highest} (both inclusive)";
        between = lowest: highest:
          assert lib.assertMsg (lowest <= highest)
            "ints.between: lowest must be smaller than highest";
          addCheck int (x: x >= lowest && x <= highest) // {
            name = "intBetween";
            description = "integer between ${betweenDesc lowest highest}";
          };
        ign = lowest: highest: name: docStart:
          between lowest highest // {
            inherit name;
            description = docStart + "; between ${betweenDesc lowest highest}";
          };
        unsign = bit: range: ign 0 (range - 1)
          "unsignedInt${toString bit}" "${toString bit} bit unsigned integer";
        sign = bit: range: ign (0 - (range / 2)) (range / 2 - 1)
          "signedInt${toString bit}" "${toString bit} bit signed integer";

      in {
        /* An int with a fixed range.
        *
        * Example:
        *   (ints.between 0 100).check (-1)
        *   => false
        *   (ints.between 0 100).check (101)
        *   => false
        *   (ints.between 0 0).check 0
        *   => true
        */
        inherit between;

        unsigned = addCheck types.int (x: x >= 0) // {
          name = "unsignedInt";
          description = "unsigned integer, meaning >=0";
        };
        positive = addCheck types.int (x: x > 0) // {
          name = "positiveInt";
          description = "positive integer, meaning >0";
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
        check = isFloat;
        merge = mergeEqualOption;
    };

    str = mkOptionType {
      name = "str";
      description = "string";
      check = isString;
      merge = mergeEqualOption;
    };

    nonEmptyStr = mkOptionType {
      name = "nonEmptyStr";
      description = "non-empty string";
      check = x: str.check x && builtins.match "[ \t\n]*" x == null;
      inherit (str) merge;
    };

    singleLineStr = mkOptionType {
      name = "singleLineStr";
      description = "string that doesn't contain '\\n'";
      check = x: str.check x && !(lib.hasInfix "\n" x);
      inherit (str) merge;
    };

    strMatching = pattern: mkOptionType {
      name = "strMatching ${escapeNixString pattern}";
      description = "string matching the pattern ${pattern}";
      check = x: str.check x && builtins.match pattern x != null;
      inherit (str) merge;
    };

    # Merge multiple definitions by concatenating them (with the given
    # separator between the values).
    separatedString = sep: mkOptionType rec {
      name = "separatedString";
      description = if sep == ""
        then "Concatenated string" # for types.string.
        else "strings concatenated with ${builtins.toJSON sep}"
      ;
      check = isString;
      merge = loc: defs: concatStringsSep sep (getValues defs);
      functor = (defaultFunctor name) // {
        payload = sep;
        binOp = sepLhs: sepRhs:
          if sepLhs == sepRhs then sepLhs
          else null;
      };
    };

    lines = separatedString "\n";
    commas = separatedString ",";
    envVar = separatedString ":";

    # Deprecated; should not be used because it quietly concatenates
    # strings, which is usually not what you want.
    string = separatedString "" // {
      name = "string";
      deprecationMessage = "See https://github.com/NixOS/nixpkgs/pull/66346 for better alternative types.";
    };

    attrs = mkOptionType {
      name = "attrs";
      description = "attribute set";
      check = isAttrs;
      merge = loc: foldl' (res: def: res // def.value) {};
      emptyValue = { value = {}; };
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "package";
      check = x: isDerivation x || isStorePath x;
      merge = loc: defs:
        let res = mergeOneOption loc defs;
        in if isDerivation res then res else toDerivation res;
    };

    shellPackage = package // {
      check = x: isDerivation x && hasAttr "shellPath" x;
    };

    path = mkOptionType {
      name = "path";
      check = x: isCoercibleToString x && builtins.substring 0 1 (toString x) == "/";
      merge = mergeEqualOption;
    };

    listOf = elemType: mkOptionType rec {
      name = "listOf";
      description = "list of ${elemType.description}s";
      check = isList;
      merge = loc: defs:
        map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:
          imap1 (m: def':
            (mergeDefinitions
              (loc ++ ["[definition ${toString n}-entry ${toString m}]"])
              elemType
              [{ inherit (def) file; value = def'; }]
            ).optionalValue
          ) def.value
        ) defs)));
      emptyValue = { value = {}; };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["*"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: listOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
      nestedTypes.elemType = elemType;
    };

    nonEmptyListOf = elemType:
      let list = addCheck (types.listOf elemType) (l: l != []);
      in list // {
        description = "non-empty " + list.description;
        # Note: emptyValue is left as is, because another module may define an element.
      };

    attrsOf = elemType: mkOptionType rec {
      name = "attrsOf";
      description = "attribute set of ${elemType.description}s";
      check = isAttrs;
      merge = loc: defs:
        mapAttrs (n: v: v.value) (filterAttrs (n: v: v ? value) (zipAttrsWith (name: defs:
            (mergeDefinitions (loc ++ [name]) elemType defs).optionalValue
          )
          # Push down position info.
          (map (def: mapAttrs (n: v: { inherit (def) file; value = v; }) def.value) defs)));
      emptyValue = { value = {}; };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: attrsOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
      nestedTypes.elemType = elemType;
    };

    # A version of attrsOf that's lazy in its values at the expense of
    # conditional definitions not working properly. E.g. defining a value with
    # `foo.attr = mkIf false 10`, then `foo ? attr == true`, whereas with
    # attrsOf it would correctly be `false`. Accessing `foo.attr` would throw an
    # error that it's not defined. Use only if conditional definitions don't make sense.
    lazyAttrsOf = elemType: mkOptionType rec {
      name = "lazyAttrsOf";
      description = "lazy attribute set of ${elemType.description}s";
      check = isAttrs;
      merge = loc: defs:
        zipAttrsWith (name: defs:
          let merged = mergeDefinitions (loc ++ [name]) elemType defs;
          # mergedValue will trigger an appropriate error when accessed
          in merged.optionalValue.value or elemType.emptyValue.value or merged.mergedValue
        )
        # Push down position info.
        (map (def: mapAttrs (n: v: { inherit (def) file; value = v; }) def.value) defs);
      emptyValue = { value = {}; };
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: lazyAttrsOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
      nestedTypes.elemType = elemType;
    };

    # TODO: drop this in the future:
    loaOf = elemType: types.attrsOf elemType // {
      name = "loaOf";
      deprecationMessage = "Mixing lists with attribute values is no longer"
        + " possible; please use `types.attrsOf` instead. See"
        + " https://github.com/NixOS/nixpkgs/issues/1800 for the motivation.";
      nestedTypes.elemType = elemType;
    };

    # Value of given type but with no merging (i.e. `uniq list`s are not concatenated).
    uniq = elemType: mkOptionType rec {
      name = "uniq";
      inherit (elemType) description check;
      merge = mergeOneOption;
      emptyValue = elemType.emptyValue;
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: uniq (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
      nestedTypes.elemType = elemType;
    };

    # Null or value of ...
    nullOr = elemType: mkOptionType rec {
      name = "nullOr";
      description = "null or ${elemType.description}";
      check = x: x == null || elemType.check x;
      merge = loc: defs:
        let nrNulls = count (def: def.value == null) defs; in
        if nrNulls == length defs then null
        else if nrNulls != 0 then
          throw "The option `${showOption loc}` is defined both null and not null, in ${showFiles (getFiles defs)}."
        else elemType.merge loc defs;
      emptyValue = { value = null; };
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: nullOr (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
      nestedTypes.elemType = elemType;
    };

    functionTo = elemType: mkOptionType {
      name = "functionTo";
      description = "function that evaluates to a(n) ${elemType.name}";
      check = isFunction;
      merge = loc: defs:
        fnArgs: (mergeDefinitions (loc ++ [ "[function body]" ]) elemType (map (fn: { inherit (fn) file; value = fn.value fnArgs; }) defs)).mergedValue;
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: functionTo (elemType.substSubModules m);
    };

    # A submodule (like typed attribute set). See NixOS manual.
    submodule = modules: submoduleWith {
      shorthandOnlyDefinesConfig = true;
      modules = toList modules;
    };

    submoduleWith =
      { modules
      , specialArgs ? {}
      , shorthandOnlyDefinesConfig ? false
      }@attrs:
      let
        inherit (lib.modules) evalModules;

        coerce = unify: value: if isFunction value
          then setFunctionArgs (args: unify (value args)) (functionArgs value)
          else unify (if shorthandOnlyDefinesConfig then { config = value; } else value);

        allModules = defs: imap1 (n: { value, file }:
          if isAttrs value || isFunction value then
            # Annotate the value with the location of its definition for better error messages
            coerce (lib.modules.unifyModuleSyntax file "${toString file}-${toString n}") value
          else value
        ) defs;

        base = evalModules {
          inherit specialArgs;
          modules = [{
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
          }] ++ modules;
        };

        freeformType = base._module.freeformType;

      in
      mkOptionType rec {
        name = "submodule";
        description = freeformType.description or name;
        check = x: isAttrs x || isFunction x || path.check x;
        merge = loc: defs:
          (base.extendModules {
            modules = [ { _module.args.name = last loc; } ] ++ allModules defs;
            prefix = loc;
          }).config;
        emptyValue = { value = {}; };
        getSubOptions = prefix: (base.extendModules
          { inherit prefix; }).options // optionalAttrs (freeformType != null) {
            # Expose the sub options of the freeform type. Note that the option
            # discovery doesn't care about the attribute name used here, so this
            # is just to avoid conflicts with potential options from the submodule
            _freeformOptions = freeformType.getSubOptions prefix;
          };
        getSubModules = modules;
        substSubModules = m: submoduleWith (attrs // {
          modules = m;
        });
        nestedTypes = lib.optionalAttrs (freeformType != null) {
          freeformType = freeformType;
        };
        functor = defaultFunctor name // {
          type = types.submoduleWith;
          payload = {
            modules = modules;
            specialArgs = specialArgs;
            shorthandOnlyDefinesConfig = shorthandOnlyDefinesConfig;
          };
          binOp = lhs: rhs: {
            modules = lhs.modules ++ rhs.modules;
            specialArgs =
              let intersecting = builtins.intersectAttrs lhs.specialArgs rhs.specialArgs;
              in if intersecting == {}
              then lhs.specialArgs // rhs.specialArgs
              else throw "A submoduleWith option is declared multiple times with the same specialArgs \"${toString (attrNames intersecting)}\"";
            shorthandOnlyDefinesConfig =
              if lhs.shorthandOnlyDefinesConfig == rhs.shorthandOnlyDefinesConfig
              then lhs.shorthandOnlyDefinesConfig
              else throw "A submoduleWith option is declared multiple times with conflicting shorthandOnlyDefinesConfig values";
          };
        };
      };

    # A value from a set of allowed ones.
    enum = values:
      let
        show = v:
               if builtins.isString v then ''"${v}"''
          else if builtins.isInt v then builtins.toString v
          else if builtins.isBool v then boolToString v
          else ''<${builtins.typeOf v}>'';
      in
      mkOptionType rec {
        name = "enum";
        description =
          # Length 0 or 1 enums may occur in a design pattern with type merging
          # where an "interface" module declares an empty enum and other modules
          # provide implementations, each extending the enum with their own
          # identifier.
          if values == [] then
            "impossible (empty enum)"
          else if builtins.length values == 1 then
            "value ${show (builtins.head values)} (singular enum)"
          else
            "one of ${concatMapStringsSep ", " show values}";
        check = flip elem values;
        merge = mergeEqualOption;
        functor = (defaultFunctor name) // { payload = values; binOp = a: b: unique (a ++ b); };
      };

    # Either value of type `t1` or `t2`.
    either = t1: t2: mkOptionType rec {
      name = "either";
      description = "${t1.description} or ${t2.description}";
      check = x: t1.check x || t2.check x;
      merge = loc: defs:
        let
          defList = map (d: d.value) defs;
        in
          if   all (x: t1.check x) defList
               then t1.merge loc defs
          else if all (x: t2.check x) defList
               then t2.merge loc defs
          else mergeOneOption loc defs;
      typeMerge = f':
        let mt1 = t1.typeMerge (elemAt f'.wrapped 0).functor;
            mt2 = t2.typeMerge (elemAt f'.wrapped 1).functor;
        in
           if (name == f'.name) && (mt1 != null) && (mt2 != null)
           then functor.type mt1 mt2
           else null;
      functor = (defaultFunctor name) // { wrapped = [ t1 t2 ]; };
      nestedTypes.left = t1;
      nestedTypes.right = t2;
    };

    # Any of the types in the given list
    oneOf = ts:
      let
        head' = if ts == [] then throw "types.oneOf needs to get at least one type in its argument" else head ts;
        tail' = tail ts;
      in foldl' either head' tail';

    # Either value of type `coercedType` or `finalType`, the former is
    # converted to `finalType` using `coerceFunc`.
    coercedTo = coercedType: coerceFunc: finalType:
      assert lib.assertMsg (coercedType.getSubModules == null)
        "coercedTo: coercedType must not have submodules (it’s a ${
          coercedType.description})";
      mkOptionType rec {
        name = "coercedTo";
        description = "${finalType.description} or ${coercedType.description} convertible to it";
        check = x: (coercedType.check x && finalType.check (coerceFunc x)) || finalType.check x;
        merge = loc: defs:
          let
            coerceVal = val:
              if coercedType.check val then coerceFunc val
              else val;
          in finalType.merge loc (map (def: def // { value = coerceVal def.value; }) defs);
        emptyValue = finalType.emptyValue;
        getSubOptions = finalType.getSubOptions;
        getSubModules = finalType.getSubModules;
        substSubModules = m: coercedTo coercedType coerceFunc (finalType.substSubModules m);
        typeMerge = t1: t2: null;
        functor = (defaultFunctor name) // { wrapped = finalType; };
        nestedTypes.coercedType = coercedType;
        nestedTypes.finalType = finalType;
      };

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = "optionSet";
      description = "option set";
      deprecationMessage = "Use `types.submodule' instead";
    };
    # Augment the given type with an additional type check function.
    addCheck = elemType: check: elemType // { check = x: elemType.check x && check x; };

  };
};

in outer_types // outer_types.types
