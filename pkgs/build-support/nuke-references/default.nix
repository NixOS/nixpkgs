# The program `nuke-refs' created by this derivation replaces all
# references to the Nix store in the specified files by a non-existent
# path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{
  lib,
  replaceVarsWith,
  perl,
  signingUtils,
  stdenvNoCC,
  shell ? stdenvNoCC.shell,
}:
replaceVarsWith {
  src = ./nuke-refs;
  replacements = {
    inherit perl; # FIXME: get rid of perl dependency.
    inherit (builtins) storeDir;
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString (
      stdenvNoCC.targetPlatform.isDarwin && stdenvNoCC.targetPlatform.isAarch64
    ) signingUtils;
  };
  dir = "bin";
  isExecutable = true;
  meta.mainProgram = "nuke-refs";
}
