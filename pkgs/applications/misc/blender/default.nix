{
  callPackage,
  darwinFrameworks,
  openexr_3,
  lib,
}: let
  versions = import ./versions.nix;
  latestStable = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  latestLTS = lib.last (builtins.sort lib.versionOlder (builtins.attrNames (lib.filterAttrs (_: v: v.isLTS == true) versions)));

  packages = hipSupport:
    lib.mapAttrs' (version: info:
      lib.nameValuePair "blender${lib.optionalString hipSupport "-hip"}_${version}" (callPackage ./generic.nix {
        inherit (darwinFrameworks) Cocoa CoreGraphics ForceFeedback OpenAL OpenGL;
        inherit (info) hash version;
        inherit hipSupport;
        openexr = openexr_3;
      }))
    versions;
in
  lib.recurseIntoAttrs
  (packages false
    // packages true
    // {
      stable = (packages false)."blender_${latestStable}";
      lts = (packages false)."blender_${latestLTS}";
    })
