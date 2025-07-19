{
  lib,
  makeSetupHook,
  findutils,
}:

{ year }:

makeSetupHook {
  name = "ensure-newer-sources-hook";
  substitutions = {
    find = lib.getExe findutils;
    inherit year;
  };
} ./hook.sh
