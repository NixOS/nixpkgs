# NOTE: Must be `import`-ed rather than `callPackage`-d to preserve the `override` attribute.
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
