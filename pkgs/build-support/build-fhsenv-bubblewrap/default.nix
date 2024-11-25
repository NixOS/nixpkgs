{ lib, callPackage }: lib.makeOverridable (args: (callPackage ./wrapper.nix { }) args)
