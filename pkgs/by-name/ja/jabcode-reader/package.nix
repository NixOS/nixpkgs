{
  lib,
  jabcode,
  ...
}@args:

lib.customisation.overrideVariant jabcode [ "jabcode" ] {
  subproject = "reader";
} args
