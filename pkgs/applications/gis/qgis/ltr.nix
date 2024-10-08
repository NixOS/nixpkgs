{ makeWrapper
, nixosTests
, symlinkJoin

, extraPythonPackages ? (ps: [ ])

# Example of unwrapped package override:
# qgis-ltr.override { unwrapped = qgis-ltr.passthru.unwrapped.override { withServer = true; }; }
, unwrapped ? libsForQt5.callPackage ./unwrapped-ltr.nix { }

, libsForQt5
}:

symlinkJoin rec {

  inherit (unwrapped) version;
  name = "qgis-${version}";

  paths = [ unwrapped ];

  nativeBuildInputs = [
    makeWrapper
    unwrapped.py.pkgs.wrapPython
  ];

  # extend to add to the python environment of QGIS without rebuilding QGIS application.
  pythonInputs = unwrapped.pythonBuildInputs ++ (extraPythonPackages unwrapped.py.pkgs);

  postBuild = ''
    buildPythonPath "$pythonInputs"

    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : $program_PATH \
        --set PYTHONPATH $program_PYTHONPATH
    done
  '';

  passthru = {
    unwrapped = unwrapped;
    tests.qgis-ltr = nixosTests.qgis-ltr;
  };

  inherit (unwrapped) meta;
}
