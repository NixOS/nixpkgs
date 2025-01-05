{
  makeWrapper,
  nixosTests,
  symlinkJoin,

  extraPythonPackages ? (ps: [ ]),

  libsForQt5,

  # unwrapped package parameters
  withGrass ? false,
  withServer ? false,
  withWebKit ? false,
}:
let
  qgis-unwrapped = libsForQt5.callPackage ./unwrapped.nix {
    withGrass = withGrass;
    withServer = withServer;
    withWebKit = withWebKit;
  };
in
symlinkJoin rec {

  inherit (qgis-unwrapped) version;
  name = "qgis-${version}";

  paths = [ qgis-unwrapped ];

  nativeBuildInputs = [
    makeWrapper
    qgis-unwrapped.py.pkgs.wrapPython
  ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = qgis-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-unwrapped.py.pkgs);

  postBuild = ''
    buildPythonPath "$pythonInputs"

    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : $program_PATH \
        --set PYTHONPATH $program_PYTHONPATH
    done
  '';

  passthru = {
    unwrapped = qgis-unwrapped;
    tests.qgis = nixosTests.qgis;
  };

  meta = qgis-unwrapped.meta;
}
