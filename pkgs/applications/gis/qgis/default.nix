<<<<<<< HEAD
{ lib
, makeWrapper
, symlinkJoin

, extraPythonPackages ? (ps: [ ])

, libsForQt5
}:
=======
{ lib, makeWrapper, symlinkJoin
, extraPythonPackages ? (ps: [ ])
, libsForQt5
}:
with lib;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  qgis-unwrapped = libsForQt5.callPackage ./unwrapped.nix {  };
in symlinkJoin rec {

  inherit (qgis-unwrapped) version;
  name = "qgis-${version}";

  paths = [ qgis-unwrapped ];

<<<<<<< HEAD
  nativeBuildInputs = [
    makeWrapper
    qgis-unwrapped.py.pkgs.wrapPython
  ];
=======
  nativeBuildInputs = [ makeWrapper qgis-unwrapped.py.pkgs.wrapPython ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-unwrapped.py.pkgs);

  postBuild = ''
    # unpackPhase

    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/qgis \
      --prefix PATH : $program_PATH \
      --set PYTHONPATH $program_PYTHONPATH
  '';

  passthru.unwrapped = qgis-unwrapped;

  meta = qgis-unwrapped.meta;
}
