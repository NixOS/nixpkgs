{ lib }:

{
  genFinalPackage = pkg: args:
    let
      expectedArgs = with lib;
        lib.naturalSort (lib.attrNames args);
      existingArgs = with lib;
        naturalSort (intersectLists expectedArgs (attrNames (functionArgs pkg.override)));
    in
      if existingArgs != expectedArgs then pkg else pkg.override args;
}
