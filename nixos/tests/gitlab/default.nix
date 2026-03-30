{ runTest }:
{
  gitlab = runTest ./gitlab.nix;
  runner = runTest ./runner.nix;
}
