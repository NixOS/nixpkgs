{ lib, makeWrapper, symlinkJoin
, qgis-unwrapped, extraPythonPackages ? (ps: [ ])
}:
with lib;
symlinkJoin rec {
  inherit (qgis-unwrapped) version;
  name = "qgis-${version}";

  paths = [ qgis-unwrapped ];

  nativeBuildInputs = [ makeWrapper qgis-unwrapped.python3Packages.wrapPython ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-unwrapped.python3Packages);

  postBuild = ''
    # unpackPhase

    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/qgis \
      --prefix PATH : $program_PATH \
      --set PYTHONPATH $program_PYTHONPATH
  '';

  meta = qgis-unwrapped.meta;
}
