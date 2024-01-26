{
  callPackage,
  lib,
  haskell,
  haskellPackages,
}:

let
  hsPkg = haskellPackages.changelog-d;

  addCompletions = haskellPackages.generateOptparseApplicativeCompletions ["changelog-d"];

  haskellModifications =
    lib.flip lib.pipe [
      addCompletions
      haskell.lib.justStaticExecutables
    ];

  mkDerivationOverrides = finalAttrs: oldAttrs: {

    version = oldAttrs.version + "-git-${lib.strings.substring 0 7 oldAttrs.src.rev}";

    # nix-shell ./maintainers/scripts/update.nix --argstr package changelog-d
    passthru.updateScript = lib.getExe (callPackage ./updateScript.nix { });

    # nix-build -A changelog-d.tests
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
