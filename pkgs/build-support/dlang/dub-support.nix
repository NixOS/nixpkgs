{
  callPackage,
  callPackages,
  ...
}:

{
  dub-to-nix = callPackage ./dub-to-nix { };
  importDubLock = callPackage ./builddubpackage/import-dub-lock.nix { };
  buildDubPackage = callPackage ./builddubpackage { };
}
// callPackages ./builddubpackage/hooks { }
