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
  qgis-ltr-unwrapped = libsForQt5.callPackage ./unwrapped-ltr.nix {
    withGrass = withGrass;
    withServer = withServer;
    withWebKit = withWebKit;
  };
in

symlinkJoin {
  inherit (qgis-ltr-unwrapped) version src;
  pname = "qgis";

  paths = [ qgis-ltr-unwrapped ];

  nativeBuildInputs = [
    makeWrapper
    qgis-ltr-unwrapped.py.pkgs.wrapPython
  ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs =
    qgis-ltr-unwrapped.pythonBuildInputs ++ (extraPythonPackages qgis-ltr-unwrapped.py.pkgs);

  postBuild = ''
    buildPythonPath "$pythonInputs"

    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : $program_PATH \
        --set PYTHONPATH $program_PYTHONPATH
    done
  '';

  passthru = {
    unwrapped = qgis-ltr-unwrapped;
    tests.qgis-ltr = nixosTests.qgis-ltr;
    updateScript = [
      ./update.sh
      "qgis-ltr"
    ];
  };

  inherit (qgis-ltr-unwrapped) meta;
}
