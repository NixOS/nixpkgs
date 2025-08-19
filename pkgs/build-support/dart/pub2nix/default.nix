{ callPackage }:

{
  readPubspecLock = callPackage ./pubspec-lock.nix { };
  generatePackageConfig = callPackage ./package-config.nix { };
  generatePackageGraph = callPackage ./package-graph/default.nix { };
}
