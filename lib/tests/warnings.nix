# Test cases for `lib.warnings.warnAlias`, see `lib/tests/warnings.sh` for more details
{
  pkgs ? import <nixpkgs> { },
}:
let
  lib = pkgs.lib;

  # renames all attr keys to xDest, e.g. drv -> drvDest
  renameDestinations =
    destinations: lib.mapAttrs' (name: value: lib.nameValuePair (name + "Dest") value) destinations;
  mkAliases =
    destinations:
    # create a lib.warnAlias for each attribute
    (lib.mapAttrs (name: value: lib.warnAlias (name + " alias") value) destinations)
    // (renameDestinations destinations);
in
(mkAliases {
  drv = pkgs.hello;
  attrs = {
    a = "b";
  };
  list = [
    1
    2
    3
  ];
  arbitrary = "abc";
})
// rec {
  func = (lib.warnAlias "func alias" (_: funcDest)) "123";
  funcDest = "abc";
}
