{
  lib,
  stdenv,
  makeSetupHook,
}:

makeSetupHook {
  name = "breakpoint-hook";
  meta = {
    broken = !stdenv.buildPlatform.isLinux;
    license = lib.licenses.mit;
  };
} ./breakpoint-hook.sh
