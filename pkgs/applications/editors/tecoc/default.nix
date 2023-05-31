{ callPackage
, lib
, fetchFromGitHub
, unstableGitUpdater
}:

let
  inherit (import ./sources.nix {
    inherit lib fetchFromGitHub unstableGitUpdater;
  }) tecoc-unstable;
in
callPackage (tecoc-unstable) {}
