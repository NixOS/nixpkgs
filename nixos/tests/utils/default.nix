{
  callPackage,
  runTest,
}:

{
  genJqSecretsReplacement = runTest ./genJqSecretsReplacement.nix;
  mkStateRevisionOption = callPackage ./mkStateRevisionOption.nix { };
}
