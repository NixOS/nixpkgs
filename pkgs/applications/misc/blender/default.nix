{ lib
, stdenv
, llvmPackages_10
, darwin
, callPackage
, python310Packages
}:

let
  versions = lib.importJSON ./versions.json;

  latestStable = lib.last (builtins.sort lib.versionOlder (builtins.attrNames versions));
  latestLTS = lib.last (builtins.sort lib.versionOlder (builtins.attrNames (lib.filterAttrs (_: v: v.isLTS == true) versions)));

  packages =
    lib.mapAttrs'
    (version: content: {
      name = "blender_${version}";
      value = callPackage ./generic.nix {
        inherit (darwin.apple_sdk.frameworks) Cocoa CoreGraphics ForceFeedback OpenAL OpenGL;

        # LLVM 11 crashes when compiling GHOST_SystemCocoa.mm
        stdenv = if stdenv.isDarwin then llvmPackages_10.stdenv else stdenv;

        # TODO Consider following https://vfxplatform.com/ for dependency tracking
        # Like "VFX_RefCY": "2024", which outlines python 3.11, qt 6.5+ etc
        pythonPackages = python310Packages;

        inherit (content) version hashes isLTS;
      };
    })
    versions;

  packages-hip =
    lib.mapAttrs'
    (packageName: package: {
      name = builtins.replaceStrings ["blender_"] [""] "blender-hip_${packageName}";
      value = package.override {hipSupport = true;};
    })
    packages;
in
  packages
  // packages-hip
  // {
    stable = packages."blender_${latestStable}";
    lts = packages."blender_${latestLTS}";
  }
