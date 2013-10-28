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
  # docPath (path concatenated to the option name contained in the option set)
  isOptionType = isType "option-type";
  mkOptionType =
    { name
    , check ? (x: true)
    , merge ? mergeDefaultOption
    , merge' ? args: merge
    , docPath ? lib.id
    }:

    { _type = "option-type";
      inherit name check merge merge' docPath;
    };


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
      merge = defs: map (def: elemType.merge [def]) (concatLists defs);
      docPath = path: elemType.docPath (path + ".*");
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
      check = x: isAttrs x && all elemType.check (lib.attrValues x);
      merge = lib.zipAttrsWith (name: elemType.merge' { inherit name; });
      docPath = path: elemType.docPath (path + ".<name>");
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertIfList = defIdx: def:
          if isList def then
            listToAttrs (
              flip imap def (elemIdx: elem:
                nameValuePair "unnamed-${toString defIdx}.${toString elemIdx}" elem))
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
        merge = defs: attrOnly.merge (imap convertIfList defs);
        docPath = path: elemType.docPath (path + ".<name?>");
      };

    uniq = elemType: mkOptionType {
      inherit (elemType) name check docPath;
      merge = list:
        if length list == 1 then
          head list
        else
          throw "Multiple definitions of ${elemType.name}. Only one is allowed for this option.";
    };

    none = elemType: mkOptionType {
      inherit (elemType) name check docPath;
      merge = list:
        throw "No definitions are allowed for this option.";
    };

    nullOr = elemType: mkOptionType {
      inherit (elemType) docPath;
      name = "null or ${elemType.name}";
      check = x: builtins.isNull x || elemType.check x;
      merge = defs:
        if all isNull defs then null
        else if any isNull defs then
          throw "Some but not all values are null."
        else elemType.merge defs;
    };

    functionTo = elemType: mkOptionType {
      name = "function that evaluates to a(n) ${elemType.name}";
      check = builtins.isFunction;
      merge = fns:
        args: elemType.merge (map (fn: fn args) fns);
    };

    submodule = opts: mkOptionType rec {
      name = "submodule";
      check = x: isAttrs x || builtins.isFunction x;
      # FIXME: make error messages include the parent attrpath.
      merge = merge' {};
      merge' = args: defs:
        let
          coerce = def: if builtins.isFunction def then def else { config = def; };
          modules = (toList opts) ++ map coerce defs;
        in (evalModules modules args).config;
    };

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = /* builtins.trace "types.optionSet is deprecated; use types.submodule instead" */ "option set";
    };

  };

}
