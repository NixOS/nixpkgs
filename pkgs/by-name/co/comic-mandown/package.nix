{
  lib,
  python3Packages,
  fetchFromGitHub,

  withGUI ? true,
}:
let
  mandown' = python3Packages.mandown.overrideAttrs (prev: {
    propagatedBuildInputs =
      prev.propagatedBuildInputs
      ++ lib.optionals withGUI prev.passthru.optional-dependencies.gui;
  });
  mandownApp = python3Packages.toPythonApplication mandown';
in
mandownApp
// {
  meta = mandownApp.meta // {
    mainProgram = "mandown";
  };
}
