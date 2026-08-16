{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qlever-control";
  version = "0.5.48";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlever-control";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mjWMRXRo2iU8C8fArXTcuVmts67MuCq8nR9dD87nR1g=";
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
    termcolor
    tqdm
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "qlever"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Command-line tool for controlling the QLever graph database";
    homepage = "https://github.com/qlever-dev/qlever-control";
    mainProgram = "qlever";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
