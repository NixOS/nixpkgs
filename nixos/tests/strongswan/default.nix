{
  system ? builtins.currentSystem,
  pkgs ? import ../../.. { inherit system; },
  lib ? pkgs.lib,
}:
let
  withPackages = with pkgs; [
    strongswan
  ];
  tests = {
    swanctl = import ./swanctl.nix;
    strongswan = import ./strongswan.nix;
  };
in
lib.mergeAttrsList (
  map (
    package:
    lib.mapAttrs' (testName: test: {
      name = "${package.pname}-${testName}";
      value = test { inherit package; };
    }) tests
  ) withPackages
)
