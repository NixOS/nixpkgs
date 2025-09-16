{ runTest }:
{
  remote-write = runTest ./remote-write.nix;
  vmalert = runTest ./vmalert.nix;
  external-promscrape-config = runTest ./external-promscrape-config.nix;
}
