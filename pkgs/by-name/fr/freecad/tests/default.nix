{ callPackage
,
}:
{
  python-path = callPackage ./python-path.nix { };
  ondsel-modules = callPackage ./ondsel-modules.nix { ;
}
