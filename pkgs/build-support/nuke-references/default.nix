# The program `nuke-refs' created by this derivation replaces all
# references to the Nix store in the specified files by a non-existant
# path (/nix/store/eeee...).  This is useful for getting rid of
# dependencies that you know are not actually needed at runtime.

{ lib, stdenvNoCC, perl, signingUtils, shell ? stdenvNoCC.shell }:

let
  stdenv = stdenvNoCC;

  darwinCodeSign = stdenv.targetPlatform.isDarwin && stdenv.targetPlatform.isAarch64;
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
    substituteAll ${./nuke-refs.sh} $out/bin/nuke-refs
    chmod a+x $out/bin/nuke-refs
  '';

  postFixup = lib.optionalString darwinCodeSign ''
    mkdir -p $out/nix-support
    substituteAll ${./darwin-sign-fixup.sh} $out/nix-support/setup-hooks.sh
  '';

  # FIXME: get rid of perl dependency.
  env = {
    inherit perl;
    inherit (builtins) storeDir;
    shell = lib.getBin shell + (shell.shellPath or "");
    signingUtils = lib.optionalString darwinCodeSign signingUtils;
  };

  meta.mainProgram = "nuke-refs";
}
