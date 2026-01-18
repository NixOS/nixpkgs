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

  inherit (lib.options)
    showDefs
    ;

  inherit (lib.strings)
    escapeNixIdentifier
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
          throw "Record field `${escapeNixIdentifier name}` must be declared with `mkField`."
        else if (field.optional or false) && (field ? default) then
          throw "Record field `${escapeNixIdentifier name}` is optional, but a `default` is provided."
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
              mergedOption = mergeDefinitions (loc ++ [ fieldName ]) field.type (
                data.${fieldName} or [ ]
                ++ optional (field ? default) {
                  value = lib.mkOptionDefault field.default;
                  file = "the default value of field ${showOption loc}";
                }
              );
              isRequired = !field.optional or false;
            in
            builtins.addErrorContext "while evaluating the field `${fieldName}' of option `${showOption loc}'" (
              optionalAttrs (isRequired || mergedOption.isDefined) {
                ${fieldName} = mergedOption.mergedValue;
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
                ${lib.concatMapAttrsStringSep "\n" (name: defs: "`${name}'${showDefs defs}") extraData}'';
        in
        if freeformType == null then checkedExtraDefs else fieldValues // extraValues;
      nestedTypes = lib.optionalAttrs (freeformType != null) {
        inherit freeformType;
      };
      # TODO: include `_freeformOptions`
      getSubOptions = prefix: lib.mapAttrs (name: field:
        mergeDefinitions (prefix ++ [ name ]) field.type [ ]
      ) checkedFields;
    };

in
# public
{
  inherit record;
}
