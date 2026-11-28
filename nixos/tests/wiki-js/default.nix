{ runTest }:
{
  v2 = runTest ./v2.nix;
  v3 = runTest ./v3.nix;
}
