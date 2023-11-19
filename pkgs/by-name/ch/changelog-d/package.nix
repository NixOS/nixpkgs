{
  cabal2nix,
  callPackage,
  lib,
  haskell,
  haskellPackages,
  writeShellApplication,
}:

let
  hsPkg = haskellPackages.changelog-d;

  haskellModifications = haskell.lib.justStaticExecutables;

  mkDerivationOverrides = finalAttrs: oldAttrs: {

    version = oldAttrs.version + "-git-${lib.strings.substring 0 7 oldAttrs.src.rev}";

    passthru.updateScript = lib.getExe (writeShellApplication {
      name = "update-changelog-d";
      runtimeInputs = [
        cabal2nix
      ];
      text = ''
        cd pkgs/development/misc/haskell/changelog-d
        cabal2nix https://codeberg.org/fgaz/changelog-d >changelog-d.nix
      '';
    });
    passthru.tests = {
      basic = callPackage ./tests/basic.nix { changelog-d = finalAttrs.finalPackage; };
    };

    meta = oldAttrs.meta // {
      homepage = "https://codeberg.org/fgaz/changelog-d";
      maintainers = [ lib.maintainers.roberth ];
    };

  };
in
  (haskellModifications hsPkg).overrideAttrs mkDerivationOverrides
