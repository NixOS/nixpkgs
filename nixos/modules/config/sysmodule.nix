{ config, lib, ... }:
let
  cfg = config.boot.kernel.sysmodule;

  kernelParamOptionType = lib.mkOptionType {
    name = "kernel command-line parameters option value";
    check =
      val:
      let
        checkType = x: lib.isBool x || lib.isString x || lib.isInt x || x == null;
      in
      checkType val || (val._type or "" == "override" && checkType val.content);
    merge = loc: defs: lib.mergeOneOption loc (lib.filterOverrides defs);
  };

in
{
  options.boot.kernel.sysmodule = lib.mkOption {
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf (lib.types.attrsOf kernelParamOptionType);
    };
  };

  config.systemd.tmpfiles.settings.sysmodule = lib.listToAttrs (
    lib.concatLists (
      lib.mapAttrsToList (
        moduleName: v:
        lib.mapAttrsToList (paramName: paramValue: {
          name = "/sys/module/${moduleName}/parameters/${paramName}";
          value = lib.mkIf (paramValue != null) {
            "w-".argument = if paramValue == false then "0" else toString paramValue;
          };
        }) v
      ) cfg
    )
  );
}
