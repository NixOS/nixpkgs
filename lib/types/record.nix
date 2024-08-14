{ lib }:

let
  inherit (lib)
    mapAttrs
    zipAttrsWith
    removeAttrs
    attrNames
    showOption
    mergeDefinitions
    mkOptionType
    isAttrs
    ;

  record =
    args@{
      fields,
      wildcard ? null,
    }:
    let
      fields = mapAttrs (
        name: value:
        if value._type or null != "option" then
          throw "Record field `${lib.escapeNixIdentifier name}` must be declared with `mkOption`."
        else if value ? apply then
          throw "In field ${lib.escapeNixIdentifier name} records do not support options with `apply`"
        else if value ? readOnly then
          throw "In field ${lib.escapeNixIdentifier name} records do not support options with `readOnly`"
        else
          value
      ) args.fields;
      wildcard =
        if args.wildcard or null == null then
          null
        else if args.wildcard._type or null != "option" then
          throw "Record wildcard must be declared with `mkOption`."
        else if args.wildcard ? apply then
          throw "Records do not support options with `apply`, but wildcard has `apply`."
        else
          args.wildcard;
    in
    mkOptionType {
      name = "record";
      description = if wildcard == null then "record" else "open record of ${wildcard.description}";
      descriptionClass = if wildcard == null then "noun" else "composite";
      check = isAttrs;
      merge =
        loc: defs:
        let
          data = zipAttrsWith (name: values: values) (
            map (
              def:
              mapAttrs (_fieldName: fieldValue: {
                inherit (def) file;
                value = fieldValue;
              }) def.value
            ) defs
          );
          requiredFieldValues = mapAttrs (
            fieldName: fieldOption:
            builtins.addErrorContext "while evaluating the field `${fieldName}' of option `${showOption loc}'" (
              (mergeDefinitions (loc ++ [ fieldName ]) fieldOption.type (
                data.${fieldName} or [ ]
                ++ (
                  if fieldOption ? default then
                    [
                      {
                        value = fieldOption.default;
                        file = "the default value of option ${showOption loc}";
                      }
                    ]
                  else
                    [ ]
                )
              )).mergedValue
            )
          ) fields;
          extraData = removeAttrs data (attrNames fields);
        in
        if wildcard == null then
          if extraData == { } then
            requiredFieldValues
          else
            throw "A definition for option `${showOption loc}' has an unknown field."
        else
          requiredFieldValues
          // mapAttrs (
            fieldName: fieldDefs:
            builtins.addErrorContext
              "while evaluating the wildcard field `${fieldName}' of option `${showOption loc}'"
              ((mergeDefinitions (loc ++ [ fieldName ]) wildcard.type fieldDefs).mergedValue)
          ) extraData;
      nestedTypes = fields // {
        # potential collision with `_wildcard` field
        # TODO: should we prevent fields from having a wildcard?
        _wildcard = wildcard;
      };
    };

in
# public
{
  inherit record;
}
