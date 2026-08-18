{
  pkgsStatic,
  lib,
  requireFile,
  emptyFile,
}:
let
  name = "this-is-a-test";
  requireFileTest =
    requireFile:
    requireFile {
      inherit name;
      url = "this-is-a-test";
      hash = lib.fakeHash;
    };
  requireFile-native = requireFileTest requireFile;
  requireFile-static = requireFileTest pkgsStatic.requireFile;
in
assert lib.assertMsg (
  requireFile-native.name == name && requireFile-static.name == name
) "requireFile derivation name must be the same across different package sets";
emptyFile
