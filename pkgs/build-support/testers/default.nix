{ pkgs, lib, callPackage }:
{
  testEqualDerivation = callPackage ./test-equal-derivation.nix { };
}
