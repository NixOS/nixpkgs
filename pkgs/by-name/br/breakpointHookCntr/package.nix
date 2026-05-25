{ stdenv, makeSetupHook }:

makeSetupHook {
  name = "breakpoint-hook";
  meta.broken = !stdenv.buildPlatform.isLinux;
} ./breakpoint-hook.sh
