# The program `remove-references-to' created by this derivation replaces all
# references to the given Nix store paths in the specified files by a
# non-existent path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{
  lib,
  replaceVarsWith,
  signingUtils,
  stdenvNoCC,
  shell ? stdenvNoCC.shell,
}:
replaceVarsWith {
  src = ./remove-references-to;
  replacements = {
    inherit (builtins) storeDir;
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString (
      stdenvNoCC.targetPlatform.isDarwin && stdenvNoCC.targetPlatform.isAarch64
    ) signingUtils;
  };
  dir = "bin";
  isExecutable = true;
  meta.mainProgram = "remove-references-to";
}
