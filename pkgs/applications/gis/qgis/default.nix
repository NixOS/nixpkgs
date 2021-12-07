{ lib, makeWrapper, symlinkJoin
, qgis-unwrapped, grass, extraPythonPackages ? (ps: [ ])
}:
with lib;
symlinkJoin rec {
  inherit (qgis-unwrapped) version;
  name = "qgis-${version}";

  paths = [ qgis-unwrapped ];

  nativeBuildInputs = [ grass makeWrapper qgis-unwrapped.python3Packages.wrapPython ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-unwrapped.python3Packages);

  postBuild = ''
    # unpackPhase

    buildPythonPath "$pythonInputs"

    wrapProgram $out/bin/qgis \
      --prefix PATH : $program_PATH \
      --prefix PATH : ${lib.makeBinPath [grass]} \
      --set PYTHONPATH $program_PYTHONPATH
  '';

  meta = qgis-unwrapped.meta;
}
