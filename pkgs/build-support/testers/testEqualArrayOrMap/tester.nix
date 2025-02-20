# NOTE: Must be `import`-ed rather than `callPackage`-d to preserve the `override` attribute.
# NOTE: We must use `pkgs.runCommand` instead of `testers.runCommand` to build `testers.testEqualArrayOrMap`, or else
# our negative tests will not work. See ./tests.nix for more information.
{
  lib,
  stdenvNoCC,
}:
let
  inherit (lib.customisation) makeOverridable;

  testEqualArrayOrMap =
    {
      name,
      valuesArray ? null,
      valuesMap ? null,
      expectedArray ? null,
      expectedMap ? null,
      script,
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      __structuredAttrs = true;
      strictDeps = true;

      inherit name;

      nativeBuildInputs = [
        ./assert-equal-array.sh
        ./assert-equal-map.sh
      ];

      inherit valuesArray valuesMap;
      inherit expectedArray expectedMap;

      inherit script;

      buildCommandPath = ./build-command.sh;
    });
in
makeOverridable testEqualArrayOrMap
