# The program `nuke-refs' created by this derivation replaces all
# references to the Nix store in the specified files by a non-existent
# path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{
  lib,
  stdenvNoCC,
  perl,
  signingUtils,
  replaceVars,
  shell ? stdenvNoCC.shell,
}:
let
  nuke-refs = replaceVars ./nuke-refs.sh {
    inherit perl; # FIXME: get rid of perl dependency.
    inherit (builtins) storeDir;
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString (
      stdenvNoCC.targetPlatform.isDarwin && stdenvNoCC.targetPlatform.isAarch64
    ) signingUtils;
  };
in
stdenvNoCC.mkDerivation {
  name = "nuke-references";

  strictDeps = true;
  enableParallelBuilding = true;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 ${nuke-refs} $out/bin/nuke-refs
  '';

  meta.mainProgram = "nuke-refs";
}
