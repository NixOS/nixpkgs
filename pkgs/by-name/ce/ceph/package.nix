{ callPackage }:

let
  scope = callPackage ./scope.nix { };
in
scope.ceph
