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
<<<<<<< HEAD
    inherit withGrass withServer withWebKit;
=======
    withGrass = withGrass;
    withServer = withServer;
    withWebKit = withWebKit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in

symlinkJoin {
<<<<<<< HEAD
  inherit (qgis-unwrapped) version outputs src;
=======
  inherit (qgis-unwrapped) version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "qgis";

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
<<<<<<< HEAD

    ln -s ${qgis-unwrapped.man} $man
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
