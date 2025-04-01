{ lib, callPackage }:
lib.makeOverridable (
  args:
  let
    buildFHSEnv = callPackage ./buildFHSEnv.nix { };
    fhsenv = buildFHSEnv args;

    wrapper = callPackage ./wrapper.nix { };
  in
  wrapper fhsenv args
)
