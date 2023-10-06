{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
, lib ? pkgs.lib
, kernelVersionsToTest ? [ "4.19" "5.4" "5.10" "5.15" "6.1" "latest" ]
}:

# For quickly running a test, the nixosTests.lvm2.lvm-thinpool-linux-latest attribute is recommended
let
  tests = let callTest = p: lib.flip (import p) { inherit system pkgs; }; in {
    thinpool = { test = callTest ./thinpool.nix; kernelFilter = lib.id; };
    # we would like to test all versions, but the kernel module currently does not compile against the other versions
    vdo = { test = callTest ./vdo.nix; kernelFilter = lib.filter (v: v == "5.15"); };


    # systemd in stage 1
    raid-sd-stage-1 = {
      test = callTest ./systemd-stage-1.nix;
      kernelFilter = lib.id;
      flavour = "raid";
    };
    thinpool-sd-stage-1 = {
      test = callTest ./systemd-stage-1.nix;
      kernelFilter = lib.id;
      flavour = "thinpool";
    };
    vdo-sd-stage-1 = {
      test = callTest ./systemd-stage-1.nix;
      kernelFilter = lib.filter (v: v == "5.15");
      flavour = "vdo";
    };
  };
in
lib.listToAttrs (
  lib.filter (x: x.value != {}) (
    lib.flip lib.concatMap kernelVersionsToTest (version:
      let
        v' = lib.replaceStrings [ "." ] [ "_" ] version;
      in
      lib.flip lib.mapAttrsToList tests (name: t:
        lib.nameValuePair "lvm-${name}-linux-${v'}" (lib.optionalAttrs (builtins.elem version (t.kernelFilter kernelVersionsToTest)) (t.test ({ kernelPackages = pkgs."linuxPackages_${v'}"; } // builtins.removeAttrs t [ "test" "kernelFilter" ])))
      )
    )
  )
)
