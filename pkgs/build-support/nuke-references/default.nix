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
  meta.description = "Replaces all references to the Nix store in the specified files with a non-existent path";
  meta.longDescription = ''
    The program `nuke-refs` created by this derivation replaces all
    references to the Nix store in the specified files by a non-existant
    path (/nix/store/eeee...).  This is useful for getting rid of
    dependencies that you know are not actually needed at runtime.

    Note that while this tool can be useful, it is not always the best
    solution.  Frequently a better way to avoid references being in the
    output is to symlink/copy all resources involved into the `/build`
    directory during the patchPhase.  Also, this tool is strictly
    _incompatible_ with any binary output that has a built-in checksum
    mechanism, as it necessarily mutates the binary.
  '';
}
