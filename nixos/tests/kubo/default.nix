{ recurseIntoAttrs, runTest }:
recurseIntoAttrs {
  kubo = runTest ./kubo.nix;
  kubo-fuse = runTest ./kubo-fuse.nix;
}
