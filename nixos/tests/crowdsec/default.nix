{ runTest }:
{
  simple = runTest ./simple.nix;
  full = runTest ./full.nix;
}
