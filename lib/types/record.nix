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
      freeformType ? null,
    }@args:
    let
      checkField =
        name: field:
        if field._type or null != "field" then
          throw "Record field `${lib.escapeNixIdentifier name}` must be declared with `mkField`."
        else
          field;

      checkFreeformType =
        type:
        if type._type or null == "option-type" then
          type
        else
          throw "Record freeformType must be declared with `mkOptionType`.";

      checkedFields = mapAttrs checkField fields;
      freeformType = if args ? freeformType then checkFreeformType args.freeformType else null;
    in
    mkOptionType {
      name = "record";
      description =
        if freeformType == null then "record" else "open record of ${freeformType.description}";
      descriptionClass = if freeformType == null then "noun" else "composite";
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
            name: defs:
            builtins.addErrorContext "while evaluating freeform value `${name}' of option `${showOption loc}'" (
              (mergeDefinitions (loc ++ [ name ]) freeformType defs).mergedValue
            )
          ) extraData;
          checkedExtraDefs =
            if extraData == { } then
              fieldValues
            else
              throw ''
                A definition for option `${showOption loc}' has an unknown fields:
                ${lib.concatMapAttrsStringSep "\n" (name: defs: "`${name}'${lib.showDefs defs}") extraData}'';
        in
        if freeformType == null then checkedExtraDefs else fieldValues // extraValues;
      nestedTypes = lib.optionalAttrs (freeformType != null) {
        inherit freeformType;
      };
      # TODO: getSubOptions for documentation purposes, etc
    };

in
# public
{
  inherit record;
}
