{
  callPackage,
  releaseVersion ? "5.0",
}:

(callPackage ./versions.nix { }).${releaseVersion}
