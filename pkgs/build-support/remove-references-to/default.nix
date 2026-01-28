# The program `remove-references-to' created by this derivation replaces all
# references to the given Nix store paths in the specified files by a
# non-existent path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{
  lib,
  stdenvNoCC,
  signingUtils,
  replaceVars,
  shell ? stdenvNoCC.shell,
}:

let
  remove-references-to = replaceVars ./remove-references-to.sh {
    inherit (builtins) storeDir;
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString (
      stdenvNoCC.targetPlatform.isDarwin && stdenvNoCC.targetPlatform.isAarch64
    ) signingUtils;
  };
in
stdenvNoCC.mkDerivation {
  name = "remove-references-to";

  strictDeps = true;
  enableParallelBuilding = true;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ${remove-references-to} $out/bin/remove-references-to
  '';

  meta.mainProgram = "remove-references-to";
}
