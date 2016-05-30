# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

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
    , # Function for building the same option type  with a different list of
      # modules.
      substSubModules ? m: null
    }:
    { _type = "option-type";
      inherit name check merge getSubOptions getSubModules substSubModules;
    };


  types = rec {

    unspecified = mkOptionType {
      name = "unspecified";
    };

    bool = mkOptionType {
      name = "boolean";
      check = isBool;
      merge = mergeEqualOption;
    };

    int = mkOptionType {
      name = "integer";
      check = isInt;
      merge = mergeOneOption;
    };

    str = mkOptionType {
      name = "string";
      check = isString;
      merge = mergeOneOption;
    };

    # Merge multiple definitions by concatenating them (with the given
    # separator between the values).
    separatedString = sep: mkOptionType {
      name = "string";
      check = isString;
      merge = loc: defs: concatStringsSep sep (getValues defs);
    };

    lines = separatedString "\n";
    commas = separatedString ",";
    envVar = separatedString ":";

    # Deprecated; should not be used because it quietly concatenates
    # strings, which is usually not what you want.
    string = separatedString "";

    attrs = mkOptionType {
      name = "attribute set";
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

    path = mkOptionType {
      name = "path";
      # Hacky: there is no ‘isPath’ primop.
      check = x: builtins.substring 0 1 (toString x) == "/";
      merge = mergeOneOption;
    };

    # drop this in the future:
    list = builtins.trace "`types.list' is deprecated; use `types.listOf' instead" types.listOf;

    listOf = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      check = isList;
      merge = loc: defs:
        map (x: x.value) (filter (x: x ? value) (concatLists (imap (n: def:
          if isList def.value then
            imap (m: def':
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
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
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
        check = x: isList x || isAttrs x;
        merge = loc: defs: attrOnly.merge loc (imap convertIfList defs);
        getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name?>"]);
        getSubModules = elemType.getSubModules;
        substSubModules = m: loaOf (elemType.substSubModules m);
      };

    # List or element of ...
    loeOf = elemType: mkOptionType {
      name = "element or list of ${elemType.name}s";
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
    };

    uniq = elemType: mkOptionType {
      inherit (elemType) name check;
      merge = mergeOneOption;
      getSubOptions = elemType.getSubOptions;
      getSubModules = elemType.getSubModules;
      substSubModules = m: uniq (elemType.substSubModules m);
    };

    nullOr = elemType: mkOptionType {
      name = "null or ${elemType.name}";
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
    };

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
        check = flip elem values;
        merge = mergeOneOption;
      };

    either = t1: t2: mkOptionType {
      name = "${t1.name} or ${t2.name}";
      check = x: t1.check x || t2.check x;
      merge = mergeOneOption;
    };

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = /* builtins.trace "types.optionSet is deprecated; use types.submodule instead" */ "option set";
    };

    # Augment the given type with an additional type check function.
    addCheck = elemType: check: elemType // { check = x: elemType.check x && check x; };

  };

}
