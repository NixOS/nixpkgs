{ runTest }:
{
  login = runTest ./login.nix;
  system = runTest ./system.nix;
}
