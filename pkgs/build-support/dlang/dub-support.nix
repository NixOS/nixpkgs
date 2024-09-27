{
  callPackage,
  ...
}:

{
  dub-to-nix = callPackage ./dub-to-nix { };
  importDubLock = callPackage ./builddubpackage/import-dub-lock.nix { };
  buildDubPackage = callPackage ./builddubpackage { };
}
// import ./builddubpackage/hooks { inherit callPackage; }
