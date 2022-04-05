{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
, lib ? pkgs.lib
, kernelVersionsToTest ? [ "4.19" "5.4" "5.10" "5.15" "latest" ]
}:

# For quickly running a test, the nixosTests.lvm2.lvm-thinpool-linux-latest attribute is recommended
let
  tests = let callTest = p: lib.flip (import p) { inherit system pkgs; }; in {
    thinpool = { test = callTest ./thinpool.nix; kernelFilter = lib.id; };
    # we would like to test all versions, but the kernel module currently does not compile against the other versions
    vdo = { test = callTest ./vdo.nix; kernelFilter = lib.filter (v: v == "5.15"); };
  };
in
lib.listToAttrs (
  lib.filter (x: x.value != {}) (
    lib.flip lib.concatMap kernelVersionsToTest (version:
      let
        v' = lib.replaceStrings [ "." ] [ "_" ] version;
      in
      lib.flip lib.mapAttrsToList tests (name: t:
        lib.nameValuePair "lvm-${name}-linux-${v'}" (lib.optionalAttrs (builtins.elem version (t.kernelFilter kernelVersionsToTest)) (t.test { kernelPackages = pkgs."linuxPackages_${v'}"; }))
      )
    )
  )
)
