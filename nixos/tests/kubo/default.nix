{ recurseIntoAttrs, runTest }:
recurseIntoAttrs {
  kubo = runTest ./kubo.nix;
  # The FUSE functionality is completely broken since Kubo v0.24.0
  # See https://github.com/ipfs/kubo/issues/10242
  # kubo-fuse = runTest ./kubo-fuse.nix;
}
