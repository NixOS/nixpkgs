# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.
{ lib }:
with lib.lists;
with lib.attrsets;
with lib.options;
with lib.trivial;
with lib.strings;
let

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
    }:
    { _type = "option-type";
      inherit name check merge getSubOptions getSubModules substSubModules typeMerge functor;
      description = if description == null then name else description;
    };


  # When adding new types don't forget to document them in
  # nixos/doc/manual/development/option-types.xml!
  types = rec {
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
        # the biggest int a 64-bit Nix accepts is 2^63 - 1 (9223372036854775808), for a 32-bit Nix it is 2^31 - 1 (2147483647)
        # the smallest int a 64-bit Nix accepts is -2^63 (-9223372036854775807), for a 32-bit Nix it is -2^31 (-2147483648)
        # u32 = unsign 32 4294967296;
        # u64 = unsign 64 18446744073709551616;

        s8 = sign 8 256;
        s16 = sign 16 65536;
        # s32 = sign 32 4294967296;
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
    string = warn "types.string is deprecated because it quietly concatenates strings"
      (separatedString "");

    attrs = mkOptionType {
      name = "attrs";
      description = "attribute set";
      check = isAttrs;
      merge = loc: foldl' (res: def: mergeAttrs res def.value) {};
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
      check = x: (package.check x) && (hasAttr "shellPath" x);
    };

    path = mkOptionType {
      name = "path";
      check = x: isCoercibleToString x && builtins.substring 0 1 (toString x) == "/";
      merge = mergeEqualOption;
    };

    # drop this in the future:
    list = builtins.trace "`types.list` is deprecated; use `types.listOf` instead" types.listOf;

    listOf = elemType: mkOptionType rec {
      name = "listOf";
      description = "list of ${elemType.description}s";
      check = isList;
      merge = loc: defs:
        map (x: x.value) (filter (x: x ? value) (concatLists (imap1 (n: def:
          if isList def.value then
            imap1 (m: def':
              (mergeDefinitions
                (loc ++ ["[definition ${toString n}-entry ${toString m}]"])
                elemType
                [{ inherit (def) file; value = def'; }]
              ).optionalValue
            ) def.value
          else
            throw "The option value `${showOption loc}` in `${def.file}` is not a list.") defs)));
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["*"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: listOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
    };

    nonEmptyListOf = elemType:
      let list = addCheck (types.listOf elemType) (l: l != []);
      in list // { description = "non-empty " + list.description; };

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
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: attrsOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertAllLists = defs:
          let
            padWidth = stringLength (toString (length defs));
            unnamedPrefix = i: "unnamed-" + fixedWidthNumber padWidth i + ".";
          in
            imap1 (i: convertIfList (unnamedPrefix i)) defs;

        convertIfList = unnamedPrefix: def:
          if isList def.value then
            let
              padWidth = stringLength (toString (length def.value));
              unnamed = i: unnamedPrefix + fixedWidthNumber padWidth i;
            in
              { inherit (def) file;
                value = listToAttrs (
                  imap1 (elemIdx: elem:
                    { name = elem.name or (unnamed elemIdx);
                      value = elem;
                    }) def.value);
              }
          else
            def;
        attrOnly = attrsOf elemType;
      in mkOptionType rec {
        name = "loaOf";
        description = "list or attribute set of ${elemType.description}s";
        check = x: isList x || isAttrs x;
        merge = loc: defs: attrOnly.merge loc (convertAllLists defs);
        getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name?>"]);
        getSubModules = elemType.getSubModules;
        substSubModules = m: loaOf (elemType.substSubModules m);
        functor = (defaultFunctor name) // { wrapped = elemType; };
      };

    # Value of given type but with no merging (i.e. `uniq list`s are not concatenated).
    uniq = elemType: mkOptionType rec {
      name = "uniq";
      inherit (elemType) description check;
      merge = mergeOneOption;
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: uniq (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
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
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: nullOr (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
    };

    # A submodule (like typed attribute set). See NixOS manual.
    submodule = opts:
      let
        opts' = toList opts;
        inherit (lib.modules) evalModules;
      in
      mkOptionType rec {
        name = "submodule";
        check = x: isAttrs x || isFunction x;
        merge = loc: defs:
          let
            coerce = def: if isFunction def then def else { config = def; };
            modules = opts' ++ map (def: { _file = def.file; imports = [(coerce def.value)]; }) defs;
          in (evalModules {
            inherit modules;
            args.name = last loc;
            prefix = loc;
          }).config;
        getSubOptions = prefix: (evalModules
          { modules = opts'; inherit prefix;
            # This is a work-around due to the fact that some sub-modules,
            # such as the one included in an attribute set, expects a "args"
            # attribute to be given to the sub-module. As the option
            # evaluation does not have any specific attribute name, we
            # provide a default one for the documentation.
            #
            # This is mandatory as some option declaration might use the
            # "name" attribute given as argument of the submodule and use it
            # as the default of option declarations.
            #
            # Using lookalike unicode single angle quotation marks because
            # of the docbook transformation the options receive. In all uses
            # &gt; and &lt; wouldn't be encoded correctly so the encoded values
            # would be used, and use of `<` and `>` would break the XML document.
            # It shouldn't cause an issue since this is cosmetic for the manual.
            args.name = "‹name›";
          }).options;
        getSubModules = opts';
        substSubModules = m: submodule m;
        functor = (defaultFunctor name) // {
          # Merging of submodules is done as part of mergeOptionDecls, as we have to annotate
          # each submodule with its location.
          payload = [];
          binOp = lhs: rhs: [];
        };
      };

    # A value from a set of allowed ones.
    enum = values:
      let
        show = v:
               if builtins.isString v then ''"${v}"''
          else if builtins.isInt v then builtins.toString v
          else ''<${builtins.typeOf v}>'';
      in
      mkOptionType rec {
        name = "enum";
        description = "one of ${concatMapStringsSep ", " show values}";
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
    };

    # Any of the types in the given list
    oneOf = ts:
      let
        head' = if ts == [] then throw "types.oneOf needs to get at least one type in its argument" else head ts;
        tail' = tail ts;
      in foldl' either head' tail';

    # Either value of type `finalType` or `coercedType`, the latter is
    # converted to `finalType` using `coerceFunc`.
    coercedTo = coercedType: coerceFunc: finalType:
      assert lib.assertMsg (coercedType.getSubModules == null)
        "coercedTo: coercedType must not have submodules (it’s a ${
          coercedType.description})";
      mkOptionType rec {
        name = "coercedTo";
        description = "${finalType.description} or ${coercedType.description} convertible to it";
        check = x: finalType.check x || (coercedType.check x && finalType.check (coerceFunc x));
        merge = loc: defs:
          let
            coerceVal = val:
              if finalType.check val then val
              else coerceFunc val;
          in finalType.merge loc (map (def: def // { value = coerceVal def.value; }) defs);
        getSubOptions = finalType.getSubOptions;
        getSubModules = finalType.getSubModules;
        substSubModules = m: coercedTo coercedType coerceFunc (finalType.substSubModules m);
        typeMerge = t1: t2: null;
        functor = (defaultFunctor name) // { wrapped = finalType; };
      };

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = builtins.trace "types.optionSet is deprecated; use types.submodule instead" "optionSet";
      description = "option set";
    };
    # Augment the given type with an additional type check function.
    addCheck = elemType: check: elemType // { check = x: elemType.check x && check x; };

  };
};

in outer_types // outer_types.types
