{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qlever-control";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlever-control";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mi2GH9/mIVg6i9txKO29lUrjM8KlBi/QG0UlUFRV7rc=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    argcomplete
    psutil
    pyyaml
    rdflib
    requests-sse
    rich
    termcolor
    textual
    textual-plotext
    tqdm
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "qlever"
  ];

  passthru.tests = nixosTests.qlever;

  meta = {
    description = "Command-line tool for controlling the QLever graph database";
    homepage = "https://github.com/qlever-dev/qlever-control";
    mainProgram = "qlever";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
