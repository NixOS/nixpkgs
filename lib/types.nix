# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

with import ./lists.nix;
with import ./attrsets.nix;
with import ./options.nix;
with import ./trivial.nix;
with import ./strings.nix;
let inherit (import ./modules.nix) mergeDefinitions filterOverrides; in

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
    type    = types."${name}" or null;
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

    int = mkOptionType rec {
      name = "int";
      description = "integer";
      check = isInt;
      merge = mergeOneOption;
    };

    str = mkOptionType {
      name = "str";
      description = "string";
      check = isString;
      merge = mergeOneOption;
    };

    # Merge multiple definitions by concatenating them (with the given
    # separator between the values).
    separatedString = sep: mkOptionType rec {
      name = "separatedString";
      description = "string";
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
    string = separatedString "";

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
      # Hacky: there is no ‘isPath’ primop.
      check = x: builtins.substring 0 1 (toString x) == "/";
      merge = mergeOneOption;
    };

    # drop this in the future:
    list = builtins.trace "`types.list' is deprecated; use `types.listOf' instead" types.listOf;

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
            throw "The option value `${showOption loc}' in `${def.file}' is not a list.") defs)));
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["*"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: listOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
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
          (map (def: listToAttrs (mapAttrsToList (n: def':
            { name = n; value = { inherit (def) file; value = def'; }; }) def.value)) defs)));
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: attrsOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // { wrapped = elemType; };
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertIfList = defIdx: def:
          if isList def.value then
            { inherit (def) file;
              value = listToAttrs (
                imap1 (elemIdx: elem:
                  { name = elem.name or "unnamed-${toString defIdx}.${toString elemIdx}";
                    value = elem;
                  }) def.value);
            }
          else
            def;
        listOnly = listOf elemType;
        attrOnly = attrsOf elemType;
      in mkOptionType rec {
        name = "loaOf";
        description = "list or attribute set of ${elemType.description}s";
        check = x: isList x || isAttrs x;
        merge = loc: defs: attrOnly.merge loc (imap1 convertIfList defs);
        getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name?>"]);
        getSubModules = elemType.getSubModules;
        substSubModules = m: loaOf (elemType.substSubModules m);
        functor = (defaultFunctor name) // { wrapped = elemType; };
      };

    # List or element of ...
    loeOf = elemType: mkOptionType rec {
      name = "loeOf";
      description = "element or list of ${elemType.description}s";
      check = x: isList x || elemType.check x;
      merge = loc: defs:
        let
          defs' = filterOverrides defs;
          res = (head defs').value;
        in
        if isList res then concatLists (getValues defs')
        else if lessThan 1 (length defs') then
          throw "The option `${showOption loc}' is defined multiple times, in ${showFiles (getFiles defs)}."
        else if !isString res then
          throw "The option `${showOption loc}' does not have a string value, in ${showFiles (getFiles defs)}."
        else res;
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
          throw "The option `${showOption loc}' is defined both null and not null, in ${showFiles (getFiles defs)}."
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
        inherit (import ./modules.nix) evalModules;
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
            # FIXME: hack to get shit to evaluate.
            args = { name = ""; }; }).options;
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
        merge = mergeOneOption;
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

    # Either value of type `finalType` or `coercedType`, the latter is
    # converted to `finalType` using `coerceFunc`.
    coercedTo = coercedType: coerceFunc: finalType:
      assert coercedType.getSubModules == null;
      mkOptionType rec {
        name = "coercedTo";
        description = "${finalType.description} or ${coercedType.description}";
        check = x: finalType.check x || coercedType.check x;
        merge = loc: defs:
          let
            coerceVal = val:
              if finalType.check val then val
              else let
                coerced = coerceFunc val;
              in assert finalType.check coerced; coerced;

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

}
