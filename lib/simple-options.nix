{
  lib,
  attrAttr ? "attrsOf",
  listAttr ? "listOf",
  subMAttr ? "options",
  typeAttr ? "type",
  debug    ? false,
  ...
}:
module:
let
  mkOptionW = breadcrumb: optName: optDef:
    let result = lib.mkOption (toOption breadcrumb optName optDef);
    in
      if debug then
        builtins.trace ''
          function: modulazy.mkOptionWrapper
          args:
            breadcrumb: ${builtins.concatStringsSep "." breadcrumb}
            optName: ${optName}
            optDef: ${builtins.concatStringsSep " " (builtins.attrNames optDef)}
          result: ${builtins.concatStringsSep " " (builtins.attrNames result)}
        ''
        result
      else result;

  toOptions = breadcrumb: options: { options = builtins.mapAttrs (mkOptionW breadcrumb) options; };

  toType    = breadcrumb: type:
    let result =
      if builtins.typeOf breadcrumb != "list"
        then builtins.throw ''breadcrumb must be a list, instead it is a ${builtins.typeOf breadcrumb}'' else
      if builtins.typeOf type       != "set"
        then builtins.throw ''type must be a attrset, instead it is a ${builtins.typeOf type}, breadcrumb: ${builtins.concatStringsSep "." breadcrumb}'' else
      if builtins.hasAttr "_type" type
        then type else
      if builtins.hasAttr typeAttr type
        then toType type.type else
      if builtins.hasAttr attrAttr type
        then lib.types.attrsOf   (toType    (breadcrumb ++ [attrAttr]) type."${attrAttr}") else
      if builtins.hasAttr listAttr type
        then lib.types.listOf    (toType    (breadcrumb ++ [listAttr]) type."${listAttr}") else
      if builtins.hasAttr subMAttr type
        then lib.types.submodule (toOptions (breadcrumb ++ [subMAttr]) type."${subMAttr}")
      else
        builtins.throw ''${builtins.concatStringsSep "." breadcrumb} has no attr _type|${typeAttr}|${attrAttr}|${listAttr}|${subMAttr}'';
    in
      if debug then
        builtins.trace ''
          function: modulazy.toType
          args:
            breadcrumb: ${builtins.concatStringsSep "." breadcrumb}
            type: ${builtins.concatStringsSep " " (builtins.attrNames type)}
          result: ${builtins.concatStringsSep " " (builtins.attrNames result)}
        ''
        result
      else result;

  toOption  = breadcrumb: optName: optDef:
    let result =
      if builtins.typeOf breadcrumb != "list"
        then builtins.throw ''breadcrumb must be a list, instead it is a ${builtins.typeOf breadcrumb}'' else
      if builtins.typeOf optName    != "string"
        then builtins.throw ''optName must be a string, instead it is a ${builtins.typeOf optName}, breadcrumb: ${builtins.concatStringsSep "." breadcrumb}'' else
      if builtins.typeOf optDef     != "set"
        then builtins.throw ''optDef must be a attrset, instead it is a ${builtins.typeOf optDef}, breadcrumb: ${builtins.concatStringsSep "." breadcrumb}, optName: ${optName}'' else
      if builtins.hasAttr typeAttr optDef
        then optDef else
      if builtins.hasAttr attrAttr optDef
        then builtins.removeAttrs optDef [attrAttr] // { type = lib.types.attrsOf   (toType    (breadcrumb ++ [optName attrAttr]) optDef."${attrAttr}");} else
      if builtins.hasAttr listAttr optDef
        then builtins.removeAttrs optDef [listAttr] // { type = lib.types.listOf    (toType    (breadcrumb ++ [optName listAttr]) optDef."${listAttr}");} else
      if builtins.hasAttr subMAttr optDef
        then builtins.removeAttrs optDef [subMAttr] // { type = lib.types.submodule (toOptions (breadcrumb ++ [optName subMAttr]) optDef."${subMAttr}");}
      else
        builtins.throw ''${builtins.concatStringsSep "." (breadcrumb ++ optName)} has no attr _type|${typeAttr}|${attrAttr}|${listAttr}|${subMAttr}'';
    in
      if debug then
        builtins.trace ''
          function: modulazy.toOption
          args:
            breadcrumb: ${builtins.concatStringsSep "." breadcrumb}
            optName: ${optName}
            optDef: ${builtins.concatStringsSep " " (builtins.attrNames optDef)}
          result: ${builtins.concatStringsSep " " (builtins.attrNames result)}
        ''
        result
      else result;
in  module // toOptions [subMAttr] module."${subMAttr}"
