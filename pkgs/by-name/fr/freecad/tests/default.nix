{
  callPackage,
}:
{
  python-path = callPackage ./python-path.nix { };
  modules = callPackage ./modules.nix { };
}
