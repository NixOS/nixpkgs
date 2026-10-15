{
  lib,
  callPackage,
}:

lib.recurseIntoAttrs {
  weak-minimax = callPackage ./weak-minimax/package.nix { };
}
