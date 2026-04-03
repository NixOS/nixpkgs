{ runTest }:
{
  chaining = runTest ./chaining.nix;
  cross-node = runTest ./cross-node.nix;
  filesecrets-hardcoded-secret = runTest ./filesecrets/hardcoded-secret.nix;
}
