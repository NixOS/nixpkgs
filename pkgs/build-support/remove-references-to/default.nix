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

let
  stdenv = stdenvNoCC;

  darwinCodeSign = stdenv.targetPlatform.isDarwin && stdenv.targetPlatform.isAarch64;
in

stdenv.mkDerivation {
  name = "remove-references-to";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    substituteAll ${./remove-references-to.sh} $out/bin/remove-references-to
    chmod a+x $out/bin/remove-references-to
  '';

  postFixup = lib.optionalString darwinCodeSign ''
    mkdir -p $out/nix-support
    substituteAll ${./darwin-sign-fixup.sh} $out/nix-support/setup-hooks.sh
  '';

  inherit (builtins) storeDir;
  shell = lib.getBin shell + (shell.shellPath or "");
  signingUtils = if darwinCodeSign then signingUtils else null;
  meta.mainProgram = "remove-references-to";
}
