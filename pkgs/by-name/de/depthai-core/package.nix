{ lib, callPackage }:

let
  mkVariant = args: (callPackage ./generic.nix { }) args;
  variants = {
    depthai-core = mkVariant {
      buildPython = true;
      enableOpencv = true;
    };

    depthai-core-minimal = mkVariant {
      buildPython = false;
      enableOpencv = false;
    };

    depthai-core-full = mkVariant {
      buildPython = true;
      enableOpencv = true;
      enableExamples = true;
      enableTests = true;
    };
  };
in
variants
