{ lib }:

let
  inherit (lib)
    mapAttrs
    concatMapAttrs
    zipAttrs
    removeAttrs
    attrNames
    showOption
    optional
    optionalAttrs
    mergeDefinitions
    mkOptionType
    isAttrs
    ;

  record =
    {
      fields ? { },
      wildcard ? null,
    }@args:
    let
      checkField =
        name: field:
        if field._type or null != "field" then
          throw "Record field `${lib.escapeNixIdentifier name}` must be declared with `mkField`."
        else
          field;
      checkedFields = mapAttrs checkField fields;
      # TODO: maybe specify a freeformType instead of a wildcard-field
      wildcard = if args ? wildcard then checkField "wildcard" args.wildcard else null;
    in
    mkOptionType {
      name = "record";
      description = if wildcard == null then "record" else "open record of ${wildcard.type.description}";
      descriptionClass = if wildcard == null then "noun" else "composite";
      check = isAttrs;
      merge =
        loc: defs:
        let
          data = zipAttrs (
            map (
              def:
              mapAttrs (_: value: {
                inherit (def) file;
                inherit value;
              }) def.value
            ) defs
          );
          fieldValues = concatMapAttrs (
            fieldName: field:
            let
              fieldOption = mergeDefinitions (loc ++ [ fieldName ]) fieldOption.type (
                data.${fieldName} or [ ]
                ++ optional (field ? default) {
                  value = lib.mkOptionDefault fieldOption.default;
                  file = "the default value of field ${showOption loc}";
                }
              );
            in
            builtins.addErrorContext "while evaluating the field `${fieldName}' of option `${showOption loc}'" (
              optionalAttrs (!field.optional || fieldOption.isDefined) {
                ${fieldName} = fieldOption.mergedValue;
              }
            )
          ) checkedFields;
          extraData = removeAttrs data (attrNames checkedFields);
          extraValues = mapAttrs (
            fieldName: fieldDefs:
            builtins.addErrorContext
              "while evaluating the wildcard field `${fieldName}' of option `${showOption loc}'"
              ((mergeDefinitions (loc ++ [ fieldName ]) wildcard.type fieldDefs).mergedValue)
          ) extraData;
        in
        if wildcard == null then
          if extraData == { } then
            fieldValues
          else
            # As per _module.check
            throw ''
              A definition for option `${showOption loc}' has an unknown fields:
              ${lib.concatMapAttrsStringSep "\n" (name: defs: "`${name}'${lib.showDefs defs}") extraData}''
        else
          fieldValues // extraValues;
      nestedTypes = checkedFields // {
        # potential collision with `_wildcard` field
        # TODO: should we prevent fields from having a wildcard?
        _wildcard = wildcard;
      };
      # TODO: getSubOptions for documentation purposes, etc
    };

in
# public
{
  inherit record;
}
