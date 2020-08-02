{ mkDerivation
, lib
, makeDesktopItem
, python3
, pyspread
}:
rec {
  wrapPyspread = import ./wrap-pyspread.nix {
    inherit mkDerivation lib makeDesktopItem;
  };

  pickRequiredDeps = if (lib.hasAttr "pickRequiredDeps" pyspread)
    then  pyspread.pickRequiredDeps else
    (ps: with ps; [
      numpy
      pyqt5
    ]);

  pickOptionalDeps = if (lib.hasAttr "pickOptionalDeps" pyspread)
    then pyspread.pickOptionalDeps else
    (ps: with ps; [
      matplotlib
      pyenchant
    ]);

  app = wrapPyspread {
    inherit pyspread;
    pythonWithPackages = (python3.withPackages (ps:
      [ pyspread ] ++
      (pickRequiredDeps ps) ++
      (pickOptionalDeps ps)
    ));
  };
}
