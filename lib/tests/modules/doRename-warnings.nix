{ lib, config, ... }:
{
  imports = [
    (lib.doRename {
      from = [
        "a"
        "b"
      ];
      to = [
        "c"
        "d"
        "e"
      ];
      warn = true;
      use = x: x;
      visible = true;
    })
  ];
  options = {
    warnings = lib.mkOption {
      type =
        let
          checkedWarningItemType =
            let
              check = x: x ? condition && x ? message;
            in
            lib.types.addCheck (lib.types.attrsOf lib.types.anything) check;

          nestedWarningAttrsType =
            let
              nestedWarningItemType = lib.types.either checkedWarningItemType (
                lib.types.attrsOf nestedWarningItemType
              );
            in
            nestedWarningItemType;
        in
        lib.types.submodule { freeformType = nestedWarningAttrsType; };
    };

    c.d.e = lib.mkOption { };
    result = lib.mkOption { };
  };
  config = {
    a.b = 1234;
    result =
      let
        warning = config.warnings.a.b.aliased;
      in
      lib.optionalString warning.condition warning.message;
  };
}
