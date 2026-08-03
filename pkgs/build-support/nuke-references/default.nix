# The program `nuke-refs' created by this derivation replaces all
# references to the Nix store in the specified files by a non-existent
# path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{
  lib,
  replaceVarsWith,
  gnused,
  signingUtils,
  stdenvNoCC,
  shell ? stdenvNoCC.shell,
}:
replaceVarsWith {
  src = ./nuke-refs;
  replacements = {
    sed = lib.getExe gnused;
    # `,` is used as the delimiter in multiple sed expressions
    storeDir = lib.escape [ "," ] builtins.storeDir;
    storeDirEscaped = lib.escape [ "," ] (lib.escapeRegex builtins.storeDir);
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString (
      stdenvNoCC.targetPlatform.isDarwin && stdenvNoCC.targetPlatform.isAarch64
    ) signingUtils;
  };
  dir = "bin";
  isExecutable = true;
  meta.mainProgram = "nuke-refs";
}
