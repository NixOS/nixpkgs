{
  callPackage,
  nixosTests,
}:
{
  python-path = callPackage ./python-path.nix { };
  modules = callPackage ./modules.nix { };
  nixos = nixosTests.freecad;
}
