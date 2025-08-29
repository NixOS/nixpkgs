# The program `remove-references-to' created by this derivation replaces all
# references to the given Nix store paths in the specified files by a
# non-existent path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{
  lib,
  stdenvNoCC,
  signingUtils,
  shell ? stdenvNoCC.shell,
}:

stdenvNoCC.mkDerivation {
  name = "remove-references-to";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    substituteAll ${./remove-references-to.sh} $out/bin/remove-references-to
    chmod a+x $out/bin/remove-references-to
  '';

  env = {
    inherit (builtins) storeDir;
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString (
      stdenvNoCC.targetPlatform.isDarwin && stdenvNoCC.targetPlatform.isAarch64
    ) signingUtils;
  };

  meta.mainProgram = "remove-references-to";
}
