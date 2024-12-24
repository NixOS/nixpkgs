{ callPackage }:
{
  buildDubPackage = callPackage ./builddubpackage { };
  dub-to-nix = callPackage ./dub-to-nix { };
}
