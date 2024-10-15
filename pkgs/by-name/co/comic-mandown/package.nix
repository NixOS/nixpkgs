{ lib
, python3Packages

, withGUI ? true
}:
let
  mandown' = python3Packages.mandown.overridePythonAttrs (prev: {
    propagatedBuildInputs = prev.propagatedBuildInputs ++ lib.optionals withGUI prev.optional-dependencies.gui;
  });
  mandownApp = python3Packages.toPythonApplication mandown';
in
mandownApp // {
  meta = mandownApp.meta // {
    mainProgram = "mandown";
  };
}
