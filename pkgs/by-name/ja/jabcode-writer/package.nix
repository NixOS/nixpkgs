{
  lib,
  jabcode,
  ...
}@args:

lib.customisation.overrideVariant {
  basePackage = jabcode;
  variantOverrides = {
    subproject = "writer";
  };
  variantArgs = args;
}
