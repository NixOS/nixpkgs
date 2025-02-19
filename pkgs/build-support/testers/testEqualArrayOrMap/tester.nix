# NOTE: Must be `import`-ed rather than `callPackage`-d to preserve the `override` attribute.
# NOTE: We must use `pkgs.runCommand` instead of `testers.runCommand` to build `testers.testEqualArrayOrMap`, or else
# our negative tests will not work. See ./tests.nix for more information.
{
  lib,
  runCommand,
}:
let
  inherit (lib) maintainers;
  inherit (lib.customisation) makeOverridable;
  inherit (lib.strings) optionalString;

  testEqualArrayOrMap =
    {
      name,
      valuesArray ? null,
      valuesMap ? null,
      expectedArray ? null,
      expectedMap ? null,
      checkSetupScript ? ''
        nixErrorLog "no checkSetupScript provided!"
        exit 1
      '',
    }:
    runCommand name
      {
        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = [
          ./assert-equal-array.sh
          ./assert-equal-map.sh
        ];

        inherit valuesArray valuesMap;
        inherit expectedArray expectedMap;

        preCheckSetupScript =
          optionalString (expectedArray == null && expectedMap == null) ''
            nixErrorLog "neither expectedArray nor expectedMap were set, so test is meaningless!"
            exit 1
          ''
          + optionalString (valuesArray != null) ''
            nixLog "using valuesArray: $(declare -p valuesArray)"
          ''
          + optionalString (valuesMap != null) ''
            nixLog "using valuesMap: $(declare -p valuesMap)"
          ''
          + optionalString (expectedArray != null) ''
            nixLog "using expectedArray: $(declare -p expectedArray)"
            declare -ag actualArray
          ''
          + optionalString (expectedMap != null) ''
            nixLog "using expectedMap: $(declare -p expectedMap)"
            declare -Ag actualMap
          '';

        # NOTE:
        # The singular task of checkSetupScript is to populate actualArray or actualMap. To do this, checkSetupScript
        # may access valuesArray, valuesMap, actualArray, and actualMap, but should *never* access or modify expectedArray,
        # or expectedMap.
        inherit checkSetupScript;

        postCheckSetupScript =
          optionalString (expectedArray != null) ''
            nixLog "using actualArray: $(declare -p actualArray)"
            nixLog "comparing actualArray against expectedArray"
            assertEqualArray expectedArray actualArray
            nixLog "actualArray matches expectedArray"
          ''
          + optionalString (expectedMap != null) ''
            nixLog "using actualMap: $(declare -p actualMap)"
            nixLog "comparing actualMap against expectedMap"
            assertEqualMap expectedMap actualMap
            nixLog "actualMap matches expectedMap"
          '';
      }
      ''
        nixLog "running preCheckSetupScript"
        runHook preCheckSetupScript

        nixLog "running checkSetupScript"
        runHook checkSetupScript

        nixLog "running postCheckSetupScript"
        runHook postCheckSetupScript

        nixLog "test passed"
        touch "$out"
      '';
in
makeOverridable testEqualArrayOrMap
