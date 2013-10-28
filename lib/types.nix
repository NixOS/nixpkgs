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


  isOptionType = isType "option-type";
  mkOptionType =
    { # Human-readable representation of the type.
      name
    , # Function applied to each definition that should return true if
      # its type-correct, false otherwise.
      check ? (x: true)
    , # Merge a list of definitions together into a single value.
      merge ? mergeDefaultOption
    , # Return a flat list of sub-options.  Used to generate
      # documentation.
      getSubOptions ? prefix: {}
    }:
    { _type = "option-type";
      inherit name check merge getSubOptions;
    };


  types = rec {

    unspecified = mkOptionType {
      name = "unspecified";
    };

    bool = mkOptionType {
      name = "boolean";
      check = builtins.isBool;
      merge = args: fold lib.or false;
    };

    int = mkOptionType {
      name = "integer";
      check = builtins.isInt;
    };

    string = mkOptionType {
      name = "string";
      check = builtins.isString;
      merge = args: lib.concatStrings;
    };

    # Like ‘string’, but add newlines between every value.  Useful for
    # configuration file contents.
    lines = mkOptionType {
      name = "string";
      check = builtins.isString;
      merge = args: lib.concatStringsSep "\n";
    };

    commas = mkOptionType {
      name = "string";
      check = builtins.isString;
      merge = args: lib.concatStringsSep ",";
    };

    envVar = mkOptionType {
      name = "environment variable";
      inherit (string) check;
      merge = args: lib.concatStringsSep ":";
    };

    attrs = mkOptionType {
      name = "attribute set";
      check = isAttrs;
      merge = args: fold lib.mergeAttrs {};
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "derivation";
      check = isDerivation;
      merge = mergeOneOption;
    };

    path = mkOptionType {
      name = "path";
      # Hacky: there is no ‘isPath’ primop.
      check = x: builtins.unsafeDiscardStringContext (builtins.substring 0 1 (toString x)) == "/";
      merge = mergeOneOption;
    };

    # drop this in the future:
    list = builtins.trace "`types.list' is deprecated; use `types.listOf' instead" types.listOf;

    listOf = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      check = value: isList value && all elemType.check value;
      merge = args: defs: imap (n: def: elemType.merge (addToPrefix args (toString n)) [def]) (concatLists defs);
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["*"]);
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
      check = x: isAttrs x && all elemType.check (lib.attrValues x);
      merge = args: lib.zipAttrsWith (name:
        elemType.merge (addToPrefix (args // { inherit name; }) name));
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
        merge = args: defs: attrOnly.merge args (imap convertIfList defs);
        getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name?>"]);
      };

    uniq = elemType: mkOptionType {
      inherit (elemType) name check;
      merge = mergeOneOption;
      getSubOptions = elemType.getSubOptions;
    };

    none = elemType: mkOptionType {
      inherit (elemType) name check;
      merge = args: list:
        throw "No definitions are allowed for the option `${showOption args.prefix}'.";
      getSubOptions = elemType.getSubOptions;
    };

    nullOr = elemType: mkOptionType {
      name = "null or ${elemType.name}";
      check = x: builtins.isNull x || elemType.check x;
      merge = args: defs:
        if all isNull defs then null
        else if any isNull defs then
          throw "The option `${showOption args.prefix}' is defined both null and not null, in ${showFiles args.files}."
        else elemType.merge args defs;
      getSubOptions = elemType.getSubOptions;
    };

    functionTo = elemType: mkOptionType {
      name = "function that evaluates to a(n) ${elemType.name}";
      check = builtins.isFunction;
      merge = args: fns:
        fnArgs: elemType.merge args (map (fn: fn fnArgs) fns);
      getSubOptions = elemType.getSubOptions;
    };

    submodule = opts:
      let opts' = toList opts; in
      mkOptionType rec {
        name = "submodule";
        check = x: isAttrs x || builtins.isFunction x;
        merge = args: defs:
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


  /* Helper function. */
  addToPrefix = args: name: args // { prefix = args.prefix ++ [name]; };

}
