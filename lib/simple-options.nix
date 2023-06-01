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
  inherit (builtins) attrNames concatStringsSep hasAttr mapAttrs throw trace typeOf;
  inherit (lib.types) attrsOf listOf submodule;
  mkOptionW = breadcrumb: optName: optDef:
    let result = lib.mkOption (toOption breadcrumb optName optDef);
    in
      if debug then
        trace ''
          function: simple-options.mkOptionWrapper
          args:
            breadcrumb: ${concatStringsSep "." breadcrumb};
            optName: ${optName}
            optDef: ${concatStringsSep " " (attrNames optDef)}
          result: ${concatStringsSep " " (attrNames result)}
        ''
        result
      else result;

  toOptions = breadcrumb: options: { options = mapAttrs (mkOptionW breadcrumb) options; };

  toType    = breadcrumb: type:
    let result =
      if typeOf breadcrumb != "list"
        then throw ''breadcrumb must be a list, instead it is a ${typeOf breadcrumb}'' else
      if typeOf type       != "set"
        then throw ''type must be a attrset, instead it is a ${typeOf type}, breadcrumb: ${concatStringsSep "." breadcrumb}'' else
      if hasAttr "_type" type
        then type else
      if hasAttr typeAttr type
        then toType type.type else
      if hasAttr attrAttr type
        then attrsOf   (toType    (breadcrumb ++ [attrAttr]) type."${attrAttr}") else
      if hasAttr listAttr type
        then listOf    (toType    (breadcrumb ++ [listAttr]) type."${listAttr}") else
      if hasAttr subMAttr type
        then submodule (toOptions (breadcrumb ++ [subMAttr]) type."${subMAttr}")
      else
        throw ''${concatStringsSep "." breadcrumb} has no attr _type|${typeAttr}|${attrAttr}|${listAttr}|${subMAttr}'';
    in
      if debug then
        trace ''
          function: simple-options.toType
          args:
            breadcrumb: ${concatStringsSep "." breadcrumb}
            type: ${concatStringsSep " " (attrNames type)}
          result: ${concatStringsSep " " (attrNames result)}
        ''
        result
      else result;

  toOption  = breadcrumb: optName: optDef:
    let result =
      if typeOf breadcrumb != "list"
        then throw ''breadcrumb must be a list, instead it is a ${typeOf breadcrumb}'' else
      if typeOf optName    != "string"
        then throw ''optName must be a string, instead it is a ${typeOf optName}, breadcrumb: ${concatStringsSep "." breadcrumb}'' else
      if typeOf optDef     != "set"
        then throw ''optDef must be a attrset, instead it is a ${typeOf optDef}, breadcrumb: ${concatStringsSep "." breadcrumb}, optName: ${optName}'' else
      if hasAttr typeAttr optDef
        then optDef else
      if hasAttr attrAttr optDef
        then removeAttrs optDef [attrAttr] // { type = attrsOf   (toType    (breadcrumb ++ [optName attrAttr]) optDef."${attrAttr}");} else
      if hasAttr listAttr optDef
        then removeAttrs optDef [listAttr] // { type = listOf    (toType    (breadcrumb ++ [optName listAttr]) optDef."${listAttr}");} else
      if hasAttr subMAttr optDef
        then removeAttrs optDef [subMAttr] // { type = submodule (toOptions (breadcrumb ++ [optName subMAttr]) optDef."${subMAttr}");}
      else
        throw ''${concatStringsSep "." (breadcrumb ++ optName)} has no attr _type|${typeAttr}|${attrAttr}|${listAttr}|${subMAttr}'';
    in
      if debug then
        trace ''
          function: simple-options.toOption
          args:
            breadcrumb: ${concatStringsSep "." breadcrumb}
            optName: ${optName}
            optDef: ${concatStringsSep " " (attrNames optDef)}
          result: ${concatStringsSep " " (attrNames result)}
        ''
        result
      else result;
in  module // toOptions [subMAttr] module."${subMAttr}"
