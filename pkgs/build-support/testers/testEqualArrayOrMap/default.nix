{
  lib,
  stdenvNoCC,
}:
let
  inherit (lib.asserts) assertMsg;
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
    assert assertMsg (
      expectedArray != null || expectedMap != null
    ) "testEqualArrayOrMap: at least one of 'expectedArray' or 'expectedMap' must be provided";
    stdenvNoCC.mkDerivation {
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
    };
in
makeOverridable testEqualArrayOrMap
