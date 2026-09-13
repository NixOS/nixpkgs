{
  lib,
  buildNpmPackage,
}:

lib.extendMkDerivation {
  constructDrv = buildNpmPackage;
  excludeDrvArgNames = [ "pluginName" ];
  extendDrvArgs =
    finalAttrs:
    {
      pluginName ? finalAttrs.pname,
      passthru ? { },
      ...
    }:
    {
      passthru = passthru // {
        inherit pluginName;
      };
    };
}
