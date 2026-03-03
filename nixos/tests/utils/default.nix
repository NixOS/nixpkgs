{ runTest }:

{
  genJqSecretsReplacement = runTest ./genJqSecretsReplacement.nix;
  genSecretsReplacement = runTest ./genSecretsReplacement.nix;
}
