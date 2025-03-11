{
  callPackage,
  releaseVersion ? "5.2",
}:

(callPackage ./versions.nix { }).${releaseVersion}
