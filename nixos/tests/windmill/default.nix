{ runTest, ... }@testArgs:
{
  apiIntegration = runTest ./api-integration.nix;
}
