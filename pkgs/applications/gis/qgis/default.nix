{
  lib,
  stdenv,
  makeWrapper,
  nixosTests,
  symlinkJoin,

  extraPythonPackages ? (ps: [ ]),

  qt6Packages,

  # unwrapped package parameters
  withGrass ? false,
  withServer ? false,
}:

let
  qgis-unwrapped = qt6Packages.callPackage ./unwrapped.nix {
    inherit withGrass withServer;
  };
in
symlinkJoin {

  inherit (qgis-unwrapped) version outputs src;
  pname = "qgis";

  paths = [ qgis-unwrapped ];

  nativeBuildInputs = [
    makeWrapper
    qgis-unwrapped.py.pkgs.wrapPython
  ];

  # Extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-unwrapped.py.pkgs);

  postBuild = ''
    buildPythonPath "$pythonInputs"

    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : $program_PATH \
        --set PYTHONHOME ${qgis-unwrapped.py} \
        --set PYTHONPATH $program_PYTHONPATH
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    QGIS_PYTHON_PATH="$out/Applications/QGIS.app/Contents/Frameworks"
    for program in $out/Applications/QGIS.app/Contents/MacOS/qgis \
                   $out/Applications/QGIS.app/Contents/MacOS/qgis_process; do
      if [[ -e "$program" ]]; then
        wrapProgram "$program" \
          --prefix PATH : $program_PATH \
          --set PYTHONHOME ${qgis-unwrapped.py} \
          --set PYTHONPATH "$QGIS_PYTHON_PATH:$program_PYTHONPATH"
      fi
    done
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    ln -s ${qgis-unwrapped.man} $man
  '';

  passthru = {
    unwrapped = qgis-unwrapped;
    tests.qgis = nixosTests.qgis;
    updateScript = [
      ./update.sh
      "qgis"
    ];
  };

  meta = qgis-unwrapped.meta;
}
