{ lib }:

{
  genFinalPackage =
    pkg: args:
    let
      expectedArgs = lib.naturalSort (lib.attrNames args);
      existingArgs =
        lib.naturalSort (lib.intersectLists expectedArgs (lib.attrNames (lib.functionArgs pkg.override)));
    in
    if existingArgs != expectedArgs then pkg else pkg.override args;
}
