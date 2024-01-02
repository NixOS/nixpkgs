{ callPackage, hello }:
{
  makeSnap = callPackage ./make-snap.nix { };
}
