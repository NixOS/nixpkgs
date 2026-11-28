{
  lib,
  jabcode,
  ...
}@args:

lib.customisation.overrideVariant {
  basePackage = jabcode;
  variantOverrides = {
    subproject = "reader";
  };
  variantArgs = args;
}
