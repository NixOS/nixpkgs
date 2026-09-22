{
  lib,
  makeSetupHook,
}:

makeSetupHook {
  name = "die-hook";
  meta.license = lib.licenses.mit;
} ./die.sh
