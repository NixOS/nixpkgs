# See https://nixos.org/manual/nixpkgs/unstable/#pkgs-nukereferences

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
