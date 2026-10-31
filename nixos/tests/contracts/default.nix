{ runTest }:
{
  chaining = runTest ./chaining.nix;
  filesecrets-hardcoded-secret = runTest ./filesecrets/hardcoded-secret.nix;
  filesecrets-hardcoded-secret-userborn = runTest ./filesecrets/hardcoded-secret-userborn.nix;
}
