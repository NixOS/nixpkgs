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
  qgis-ltr-unwrapped = libsForQt5.callPackage ./unwrapped-ltr.nix {  };
in symlinkJoin rec {

  inherit (qgis-ltr-unwrapped) version;
  name = "qgis-${version}";

  paths = [ qgis-ltr-unwrapped ];

<<<<<<< HEAD
  nativeBuildInputs = [
    makeWrapper
    qgis-ltr-unwrapped.py.pkgs.wrapPython
  ];
=======
  nativeBuildInputs = [ makeWrapper qgis-ltr-unwrapped.py.pkgs.wrapPython ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-ltr-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-ltr-unwrapped.py.pkgs);

  postBuild = ''
    # unpackPhase

    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/qgis \
      --prefix PATH : $program_PATH \
      --set PYTHONPATH $program_PYTHONPATH
  '';

  passthru.unwrapped = qgis-ltr-unwrapped;

  inherit (qgis-ltr-unwrapped) meta;
}
