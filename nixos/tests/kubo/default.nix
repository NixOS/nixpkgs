{ lib, runTest }:
lib.recurseIntoAttrs {
  kubo = runTest ./kubo.nix;
  kubo-fuse = runTest ./kubo-fuse.nix;
}
