{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitea,
  runCommand,
  lctime,
  ngspice,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "lctime";
<<<<<<< HEAD
  version = "0.0.27";
=======
  version = "0.0.26";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "librecell";
    repo = "lctime";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-KKZhsKNTr+J5+rLUdlwGMsUCa6NYY1X9yaujPe1c0Do=";
=======
    hash = "sha256-oNmeV8r1dtO2y27jAJnlx4mKGjhzL07ad2yBdOLwgF0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    joblib
    klayout
    liberty-parser
<<<<<<< HEAD
=======
    matplotlib
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    networkx
    numpy
    pyspice
    scipy
    sympy
  ];

<<<<<<< HEAD
  optional-dependencies.debug = with python3Packages; [ matplotlib ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    ngspice
  ];

  enabledTestPaths = [
    "src/lctime/*/*.py"
  ];

  disabledTestPaths = [
    # hangs indefinitely
    "src/lctime/characterization/test_ngspice_subprocess.py::test_ngspice_interactive_simple"
    "src/lctime/characterization/test_ngspice_subprocess.py::test_ngspice_subprocess_class"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # causes python to abort
    "src/lctime/characterization/test_ngspice_subprocess.py::test_simple_simulation"
    # broken pipe
    "src/lctime/characterization/test_ngspice_subprocess.py::test_interactive_subprocess"
  ];

  pythonImportsCheck = [
    "lctime"
  ];

  passthru = {
    tests =
      runCommand "lctime-tests"
        {
          nativeBuildInputs = [
            lctime
            ngspice
            writableTmpDirAsHomeHook
          ];
        }
        ''
          cd "$HOME"

          cp -R "${src}/tests/"* .
          patchShebangs *.sh

          mkdir -p $out
          ./run_tests.sh &> $out/result.log
        '';
  };

  meta = {
    description = "Characterization tool for CMOS digital standard-cells";
    homepage = "https://codeberg.org/librecell/lctime";
    license = with lib.licenses; [
      agpl3Plus
      asl20
      cc-by-sa-40
      cc0
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "lctime";
  };
}
