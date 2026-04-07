{ callPackage }:

{
  readPubspecLock = callPackage ./pubspec-lock.nix { };
}
