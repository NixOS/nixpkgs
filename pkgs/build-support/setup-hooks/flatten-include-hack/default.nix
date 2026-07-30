{
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "flatten-include-hack-hook";
  meta.license = lib.licenses.mit;
} ./flatten-include-hack-hook.sh
