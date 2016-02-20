# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

let lib = import ./default.nix; in

with import ./lists.nix;
with import ./attrsets.nix;
with import ./options.nix;
with import ./trivial.nix;
with import ./strings.nix;
with {inherit (import ./modules.nix) mergeDefinitions filterOverrides; };

rec {

  isType = type: x: (x._type or "") == type;

  setType = typeName: value: value // {
    _type = typeName;
  };


  isOptionType = isType "option-type";
  mkOptionType =
    { # Human-readable representation of the type.
      name
    , # Parseable representation of the type.
      typerep
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
    , # Return list of sub-options.
      getSubOptions ? {}
    , # Same as 'getSubOptions', but with extra information about the
      # location of the option which is used to generate documentation.
      getSubOptionsPrefixed ? null
    , # List of modules if any, or null if none.
      getSubModules ? null
    , # Function for building the same option type  with a different list of
      # modules.
      substSubModules ? m: null
    , # List of type representations (typerep) of all the elementary types
      # that are nested within the type. For an elementary type the list is
      # a singleton of the typerep of itself.
      # NOTE: Must be specified for every container type!
      nestedTypes ? null
    , # List of all default values, and an empty list if no default value exists.
      defaultValues ? []
    }:
    { _type = "option-type";
      inherit name typerep check merge getSubOptions getSubModules substSubModules defaultValues;
      nestedTypes = if (isNull nestedTypes) then (singleton typerep) else nestedTypes;
      getSubOptionsPrefixed = if (isNull getSubOptionsPrefixed) then (prefix: getSubOptions) else getSubOptionsPrefixed;
    };


  types = rec {

    #
    # Elementary types
    #

    unspecified = mkOptionType {
      name = "unspecified";
      typerep = "(unspecified)";
    };

    bool = mkOptionType {
      name = "boolean";
      typerep = "(boolean)";
      check = isBool;
      merge = mergeEqualOption;
    };

    int = mkOptionType {
      name = "integer";
      typerep = "(integer)";
      check = isInt;
      merge = mergeOneOption;
    };

    str = mkOptionType {
      name = "string";
      typerep = "(string)";
      check = isString;
      merge = mergeOneOption;
    };

    # Merge multiple definitions by concatenating them (with the given
    # separator between the values).
    separatedString = sep: mkOptionType {
      name = "string" + (optionalString (sep != "") " separated by ${sep}");
      typerep = "(separatedString(${escape ["(" ")"] sep}))";
      check = isString;
      merge = _module: loc: defs: concatStringsSep sep (getValues defs);
    };

    lines = separatedString "\n" // { typerep = "(lines)"; };
    commas = separatedString "," // { typerep = "(commas)"; };
    envVar = separatedString ":" // { typerep = "(envVar)"; };

    # Deprecated; should not be used because it quietly concatenates
    # strings, which is usually not what you want.
    string = separatedString "" // { typerep = "(string)"; };

    attrs = mkOptionType {
      name = "attribute set";
      typerep = "(attrs)";
      check = isAttrs;
      merge = _module: loc: foldl' (res: def: mergeAttrs res def.value) {};
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "package";
      typerep = "(package)";
      check = x: isDerivation x || isStorePath x;
      merge = _module: loc: defs:
        let res = mergeOneOption _module loc defs;
        in if isDerivation res then res else toDerivation res;
    };

    # The correct type of packageSet would be:
    # packageSet = attrsOf (either package packageSet)
    # (Not sure if nix would allow to define a recursive type.)
    # However, currently it is not possible to check that a packageSet actually
    # contains packages (that is derivations). The check 'isDerivation' is too
    # eager for the current implementation of the assertion mechanism and of the
    # licenses control mechanism. That means it is not generally possible to go
    # into the attribute set of packages to check that every attribute would
    # evaluate to a derivation if the package would actually be evaluated. Maybe
    # that restriction can be lifted in the future, but for now the content of
    # the packageSet is not checked.
    # TODO: The 'merge' function is copied from 'mergeDefaultOption' to keep
    # backwards compatibility with the 'unspecified' type that was used for
    # package sets previously. Maybe review if the merge function has to change.
    packageSet = mkOptionType {
      name = "derivation set";
      typerep = "(packageSet)";
      check = isAttrs;
      merge = _module: loc: defs: foldl' mergeAttrs {} (map (x: x.value) defs);
    };

    path = mkOptionType {
      name = "path";
      typerep = "(path)";
      # Hacky: there is no ‘isPath’ primop.
      check = x: builtins.substring 0 1 (toString x) == "/";
      merge = mergeOneOption;
    };


    #
    # Container types
    #

    # drop this in the future:
    list = builtins.trace "`types.list' is deprecated; use `types.listOf' instead" types.listOf;

    listOf = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      typerep = "(listOf${elemType.typerep})";
      check = isList;
      merge = _module: loc: defs:
        map (x: x.value) (filter (x: x ? value) (concatLists (imap (n: def: imap (m: def':
            (mergeDefinitions _module
              (loc ++ ["[definition ${toString n}-entry ${toString m}]"])
              elemType
              [{ inherit (def) file; value = def'; }]
            ).optionalValue
          ) def.value) defs)));
      getSubOptions = elemType.getSubOptions;
      getSubOptionsPrefixed = prefix: elemType.getSubOptionsPrefixed (prefix ++ ["*"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: listOf (elemType.substSubModules m);
      nestedTypes = elemType.nestedTypes;
      defaultValues = [[]];
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
      typerep = "(attrsOf${elemType.typerep})";
      check = isAttrs;
      merge = _module: loc: defs:
        mapAttrs (n: v: v.value) (filterAttrs (n: v: v ? value) (zipAttrsWith (name: defs:
            (mergeDefinitions _module (loc ++ [name]) elemType defs).optionalValue
          )
          # Push down position info.
          (map (def: listToAttrs (mapAttrsToList (n: def':
            { name = n; value = { inherit (def) file; value = def'; }; }) def.value)) defs)));
      getSubOptions = elemType.getSubOptions;
      getSubOptionsPrefixed = prefix: elemType.getSubOptionsPrefixed (prefix ++ ["<name>"]);
      getSubModules = elemType.getSubModules;
      substSubModules = m: attrsOf (elemType.substSubModules m);
      nestedTypes = elemType.nestedTypes;
      defaultValues = [{}];
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertIfList = defIdx: def:
          if isList def.value then
            { inherit (def) file;
              value = listToAttrs (
                imap (elemIdx: elem:
                  { name = elem.name or "unnamed-${toString defIdx}.${toString elemIdx}";
                    value = elem;
                  }) def.value);
            }
          else
            def;
        listOnly = listOf elemType;
        attrOnly = attrsOf elemType;
      in mkOptionType {
        name = "list or attribute set of ${elemType.name}s";
        typerep = "(loaOf${elemType.typerep})";
        check = x: isList x || isAttrs x;
        merge = _module: loc: defs: attrOnly.merge _module loc (imap convertIfList defs);
        getSubOptions = elemType.getSubOptions;
        getSubOptionsPrefixed = prefix: elemType.getSubOptionsPrefixed (prefix ++ ["<name?>"]);
        getSubModules = elemType.getSubModules;
        substSubModules = m: loaOf (elemType.substSubModules m);
        nestedTypes = elemType.nestedTypes;
        defaultValues = [{} []];
      };

    # List or element of ...
    loeOf = elemType: mkOptionType {
      name = "element or list of ${elemType.name}s";
      typerep = "(loeOf${elemType.typerep})";
      check = x: isList x || elemType.check x;
      merge = _module: loc: defs:
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
      nestedTypes = elemType.nestedTypes;
      defaultValues = [[]] ++ elemType.defaultValues;
    };

    uniq = elemType: mkOptionType {
      inherit (elemType) check;
      name = "unique ${elemType.name}";
      typerep = "(uniq${elemType.typerep})";
      merge = mergeOneOption;
      getSubOptions = elemType.getSubOptions;
      getSubOptionsPrefixed = prefix: elemType.getSubOptionsPrefixed prefix;
      getSubModules = elemType.getSubModules;
      substSubModules = m: uniq (elemType.substSubModules m);
      nestedTypes = elemType.nestedTypes;
      defaultValues = elemType.defaultValues;
    };

    nullOr = elemType: mkOptionType {
      name = "null or ${elemType.name}";
      typerep = "(nullOr${elemType.typerep})";
      check = x: x == null || elemType.check x;
      merge = _module: loc: defs:
        let nrNulls = count (def: def.value == null) defs; in
        if nrNulls == length defs then null
        else if nrNulls != 0 then
          throw "The option `${showOption loc}' is defined both null and not null, in ${showFiles (getFiles defs)}."
        else elemType.merge _module loc defs;
      getSubOptions = elemType.getSubOptions;
      getSubOptionsPrefixed = prefix: elemType.getSubOptionsPrefixed prefix;
      getSubModules = elemType.getSubModules;
      substSubModules = m: nullOr (elemType.substSubModules m);
      nestedTypes = elemType.nestedTypes;
      defaultValues = [null] ++ elemType.defaultValues;
    };

    enum = values:
      let
        show = v:
               if builtins.isString v then ''"${v}"''
          else if builtins.isInt v then builtins.toString v
          else ''<${builtins.typeOf v}>'';
      in
      mkOptionType {
        name = "one of ${concatMapStringsSep ", " show values}";
        typerep = "(enum${concatMapStrings (x: "(${escape ["(" ")"] (builtins.toString x)})") values})";
        check = flip elem values;
        merge = mergeOneOption;
        nestedTypes = [];
      };

    either = t1: t2: mkOptionType {
      name = "${t1.name} or ${t2.name}";
      typerep = "(either${t1.typerep}${t2.typerep})";
      check = x: t1.check x || t2.check x;
      merge = mergeOneOption;
      nestedTypes = t1.nestedTypes ++ t2.nestedTypes;
      defaultValues = t1.defaultValues ++ t2.defaultValues;
    };


    #
    # Complex types
    #

    submodule = opts:
      let
        opts' = toList opts;
        inherit (import ./modules.nix) evalModules;
        filterVisible = filter (opt: (if opt ? visible then opt.visible else true) && (if opt ? internal then !opt.internal else true));
      in
      mkOptionType rec {
        name = "submodule";
        typerep = "(submodule)";
        check = x: isAttrs x || isFunction x;
        merge = _module: loc: defs:
          let
            internalModule = [ { inherit _module; } { _module.args.name = lib.mkForce (last loc); } ];
            coerce = def: if isFunction def then def else { config = def; };
            modules = opts' ++ internalModule ++ map (def: { _file = def.file; imports = [(coerce def.value)]; }) defs;
          in (evalModules {
            inherit modules;
            prefix = loc;
          }).config;
        getSubOptions = getSubOptionsPrefixed [];
        getSubOptionsPrefixed = prefix: _module:
          let
            # FIXME: hack to get shit to evaluate.
            internalModule = [ { inherit _module; } { _module.args.name = lib.mkForce ""; } ];
          in (evalModules {
            modules = opts' ++ internalModule;
            inherit prefix;
          }).options;
        getSubModules = opts';
        substSubModules = m: submodule m;
        nestedTypes = concatMap (opt: opt.type.nestedTypes) (collect (lib.isType "option") (getSubOptions {}));
        defaultValues = [{}];
      };



    #
    # Legacy types
    #

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = /* builtins.trace "types.optionSet is deprecated; use types.submodule instead" */ "option set";
      typerep = "(optionSet)";
    };


    # Try to remove module options of that type wherever possible.
    # A module option taking a function can not be introspected and documented properly.
    functionTo = resultType:
      mkOptionType {
        name = "function to ${resultType.name}";
        typerep = "(function${resultType.typerep})";
        check = builtins.isFunction;
        merge = mergeOneOption;
        nestedTypes = resultType.nestedTypes;
        defaultValues = map (x: {...}:x) resultType.nestedTypes; # INFO: It seems as nix can't compare functions, yet.
      };


    #
    # misc
    #

    # Augment the given type with an additional type check function.
    addCheck = elemType: check: elemType // { check = x: elemType.check x && check x; };

  };

}
