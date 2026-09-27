{
  # keep-sorted start
  lib,
  makeSetupHook,
  patchelf,
  stdenv,
  # keep-sorted end
}:
makeSetupHook {
  name = "shared-libs-hook";
  substitutions = {
    patchelf = lib.getExe patchelf;
    darwinLibxml = lib.optionalString stdenv.hostPlatform.isAarch "--replace-needed libxml2.so.2 libxml2.so";
  };
  meta = {
    description = "Setup hook that rewrites sonames in libraries bundled with JetBrains IDEs";
    teams = [ lib.teams.jetbrains ];
  };
} ./shared-libs-hook.sh
