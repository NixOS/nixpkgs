{ lib, runTest, ... }:
let
  inherit (lib) recurseIntoAttrs mapAttrs const;

  packages = {
    mainline = builtins.getAttr "nginxMainline";
    stable = builtins.getAttr "nginxStable";
  };
in
recurseIntoAttrs (
  mapAttrs (
    name: mkPackage:
    let
      callTest = path: runTest (import path { inherit mkPackage name lib; });
    in
    mapAttrs (const callTest) {
      basic = ./basic.nix;
      compression = ./compression.nix;
      etag = ./etag.nix;
      etag-compression = ./etag-compression.nix;
      globalredirect = ./globalredirect.nix;
      dynamic-modules = ./dynamic-modules.nix;
      grpc-error-pages = ./grpc-error-pages.nix;
    }
  ) packages
)
