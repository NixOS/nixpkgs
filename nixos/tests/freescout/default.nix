{ runTest }:
{
  integration = runTest ./integration.nix;
  upgrade = runTest ./upgrade.nix;
}
