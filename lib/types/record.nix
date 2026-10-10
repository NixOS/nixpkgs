{ lib }:

let
  inherit (lib)
    types
    mapAttrs
    attrNames
    showOption
    mkOptionType
    isAttrs
    ;

  inherit (types)
    unspecified
    optionDescriptionPhrase
    ;

  record =
    {
      optional ? { },
      required ? { },
      wildcardType ? null,
    }:
    let
      # Matches the behavior of fixupOptionType
      # Adds types.unspecified for options that have no type
      fixupFieldType =
        name:
        let
          decl = optional.${name} or required.${name} or null;
        in
        if decl != null then decl // { type = decl.type or unspecified; } else null;
    in
    mkOptionType {
      name = "record";
      description =
        if wildcardType == null then
          "record"
        else
          "open record of ${
            optionDescriptionPhrase (class: class == "noun" || class == "composite") wildcardType
          }";
      descriptionClass = if wildcardType == null then "noun" else "composite";
      check = isAttrs;
      merge.v2 =
        { loc, defs }:
        let
          pushPositions = map (
            def:
            mapAttrs (n: v: {
              inherit (def) file;
              value = v;
            }) def.value
          );

          # Checks
          intersection = lib.intersectAttrs optional required;
          optionalDefault = lib.filterAttrs (_: opt: opt ? default) optional;

          # Definitions + option defaults
          allDefs =
            defs
            ++ (lib.mapAttrsToList (name: opt: {
              file = (builtins.unsafeGetAttrPos name required).file or "<unknown-file>";
              value = {
                ${name} = lib.mkOptionDefault opt.default;
              };
            }) (lib.filterAttrs (n: opt: opt ? default) required));

          merged = lib.zipAttrsWith (
            name: defs:
            let
              # elemType = optional.${name}.type or required.${name}.type or wildcardType;
              elemType = (fixupFieldType name).type or wildcardType;
            in
            lib.modules.mergeDefinitions (loc ++ [ name ]) elemType defs
          ) (pushPositions allDefs);
        in
        {
          headError =
            if intersection != { } then
              {
                message = "The following attributes of '${showOption loc}' are both declared in 'optional' and in 'required': ${lib.concatStringsSep ", " (attrNames intersection)}";
              }
            else if optionalDefault != { } then
              {
                message = "The following attributes of '${showOption loc}' are declared in 'optional' cannot have a default value: ${lib.concatStringsSep ", " (attrNames optionalDefault)}";
              }
            else
              null;
          # TODO: expose fields, fieldValues and extraValues
          valueMeta = {
            attrs = mapAttrs (n: v: v.checkedAndMerged.valueMeta) merged;
          };
          value = mapAttrs (
            name: v:
            let
              elemType = (fixupFieldType name).type or wildcardType;
            in
            if required ? ${name} then
              # Non-optional, lazy ?
              v.mergedValue
            else
              # Optional, lazy
              v.optionalValue.value or elemType.emptyValue.value or v.mergedValue
          ) merged;
        };
      nestedTypes = lib.optionalAttrs (wildcardType != null) {
        inherit wildcardType;
      };
      getSubOptions =
        prefix:
        # Since this type doesn't support type merging, we can safely use the original attrs to display documentation.
        lib.mapAttrs (
          name: opt:
          (
            opt
            // {
              loc = prefix ++ [ name ];
              inherit name;
              declarations = [
                (builtins.unsafeGetAttrPos name optional).file or (builtins.unsafeGetAttrPos name required).file
                  or "<unknown-file>"
              ];
            }
          )
        ) (mapAttrs (n: o: fixupFieldType n) (optional // required));
    };

in
# public
{
  inherit record;
}
