{
  runTest,
  ...
}:
{
  auth-fake = runTest ./auth-fake.nix;
  auth-oidc = runTest ./auth-oidc.nix;
}
