{
  lib,
  fetchFromGitHub,
  callPackage,
  zig_0_13,
}:
let
  versions = [
    {
      zig = zig_0_13;
      version = "0-unstable-06-01";
      src = fetchFromGitHub {
        owner = "Vexu";
        repo = "arocc";
        rev = "55cb6d1b682b83f75ad4f60e34c6fcd2336e8531";
        hash = "sha256-xs3zNQIC5drrQYT4nxL7Q69xSEdbdMv5+3hQpsX3q5A=";
      };
    }
  ];

  mkPackage =
    {
      zig,
      version,
      src,
    }:
    callPackage ./package.nix { inherit zig version src; };

  pkgsList = lib.map mkPackage versions;

  pkgsAttrsUnwrapped = lib.listToAttrs (
    lib.map (pkg: lib.nameValuePair "${pkg.version}-unwrapped" pkg) pkgsList
  );
  pkgsAttrsWrapped = lib.listToAttrs (
    lib.map (pkg: lib.nameValuePair pkg.version pkg.wrapped) pkgsList
  );

  pkgsAttrs = pkgsAttrsWrapped // pkgsAttrsUnwrapped;
in
{
  latest-unwrapped = lib.last pkgsList;
  latest = (lib.last pkgsList).wrapped;
}
// pkgsAttrs
