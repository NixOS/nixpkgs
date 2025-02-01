{
  callPackage,
  freecad,
}:
{
  python-path = callPackage ./python-path.nix { };
  modules = callPackage ./modules.nix { };
  withIfcSupport = freecad.override { ifcSupport = true; };
}
