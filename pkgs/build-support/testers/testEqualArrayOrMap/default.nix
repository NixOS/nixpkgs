{
  lib,
  stdenvNoCC,
}:
lib.makeOverridable (
  {
    name,
    valuesArray ? null,
    valuesMap ? null,
    expectedArray ? null,
    expectedMap ? null,
    script,
  }:
  assert lib.assertMsg (
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
  }
)
