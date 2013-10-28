# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

let lib = import ./default.nix; in

with lib.lists;
with lib.attrsets;
with lib.options;
with lib.trivial;
with lib.modules;

rec {

  isType = type: x: (x._type or "") == type;
  typeOf = x: x._type or "";

  setType = typeName: value: value // {
    _type = typeName;
  };


  # name (name of the type)
  # check (check the config value)
  # merge (default merge function)
  # getSubOptions (returns sub-options for manual generation)
  isOptionType = isType "option-type";
  mkOptionType =
    { name
    , check ? (x: true)
    , merge ? mergeDefaultOption
    , merge' ? args: merge
    , getSubOptions ? prefix: {}
    }:

    { _type = "option-type";
      inherit name check merge merge' getSubOptions;
    };


  addToPrefix = args: name: args // { prefix = args.prefix ++ [name]; };


  types = rec {

    unspecified = mkOptionType {
      name = "unspecified";
    };

    bool = mkOptionType {
      name = "boolean";
      check = builtins.isBool;
      merge = fold lib.or false;
    };

    int = mkOptionType {
      name = "integer";
      check = builtins.isInt;
    };

    string = mkOptionType {
      name = "string";
      check = builtins.isString;
      merge = lib.concatStrings;
    };

    # Like ‘string’, but add newlines between every value.  Useful for
    # configuration file contents.
    lines = mkOptionType {
      name = "string";
      check = builtins.isString;
      merge = lib.concatStringsSep "\n";
    };

    commas = mkOptionType {
      name = "string";
      check = builtins.isString;
      merge = lib.concatStringsSep ",";
    };

    envVar = mkOptionType {
      name = "environment variable";
      inherit (string) check;
      merge = lib.concatStringsSep ":";
    };

    attrs = mkOptionType {
      name = "attribute set";
      check = isAttrs;
      merge = fold lib.mergeAttrs {};
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "derivation";
      check = isDerivation;
    };

    path = mkOptionType {
      name = "path";
      # Hacky: there is no ‘isPath’ primop.
      check = x: builtins.unsafeDiscardStringContext (builtins.substring 0 1 (toString x)) == "/";
    };

    # drop this in the future:
    list = builtins.trace "types.list is deprecated; use types.listOf instead" types.listOf;

    listOf = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      check = value: isList value && all elemType.check value;
      merge' = args: defs: imap (n: def: elemType.merge' (addToPrefix args (toString n)) [def]) (concatLists defs);
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["*"]);
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
      check = x: isAttrs x && all elemType.check (lib.attrValues x);
      merge' = args: lib.zipAttrsWith (name:
        elemType.merge' (addToPrefix (args // { inherit name; }) name));
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertIfList = defIdx: def:
          if isList def then
            listToAttrs (
              flip imap def (elemIdx: elem:
                { name = "unnamed-${toString defIdx}.${toString elemIdx}"; value = elem; }))
          else
            def;
        listOnly = listOf elemType;
        attrOnly = attrsOf elemType;

      in mkOptionType {
        name = "list or attribute set of ${elemType.name}s";
        check = x:
          if isList x       then listOnly.check x
          else if isAttrs x then attrOnly.check x
          else false;
        merge' = args: defs: attrOnly.merge' args (imap convertIfList defs);
        getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name?>"]);
      };

    uniq = elemType: mkOptionType {
      inherit (elemType) name check;
      merge = list:
        if length list == 1 then
          head list
        else
          throw "Multiple definitions of ${elemType.name}. Only one is allowed for this option.";
      getSubOptions = elemType.getSubOptions;
    };

    none = elemType: mkOptionType {
      inherit (elemType) name check;
      merge = list:
        throw "No definitions are allowed for this option.";
      getSubOptions = elemType.getSubOptions;
    };

    nullOr = elemType: mkOptionType {
      name = "null or ${elemType.name}";
      check = x: builtins.isNull x || elemType.check x;
      merge' = args: defs:
        if all isNull defs then null
        else if any isNull defs then
          throw "Some but not all values are null."
        else elemType.merge' args defs;
      getSubOptions = elemType.getSubOptions;
    };

    functionTo = elemType: mkOptionType {
      name = "function that evaluates to a(n) ${elemType.name}";
      check = builtins.isFunction;
      merge' = args: fns:
        fnArgs: elemType.merge' args (map (fn: fn fnArgs) fns);
      getSubOptions = elemType.getSubOptions;
    };

    submodule = opts:
      let opts' = toList opts; in
      mkOptionType rec {
        name = "submodule";
        check = x: isAttrs x || builtins.isFunction x;
        merge = merge' {};
        merge' = args: defs:
          let
            coerce = def: if builtins.isFunction def then def else { config = def; };
            modules = opts' ++ map coerce defs;
          in (evalModules { inherit modules args; prefix = args.prefix; }).config;
        getSubOptions = prefix: (evalModules
          { modules = opts'; inherit prefix;
            # FIXME: hack to get shit to evaluate.
            args = { name = ""; }; }).options;
      };

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = /* builtins.trace "types.optionSet is deprecated; use types.submodule instead" */ "option set";
    };

  };

}
