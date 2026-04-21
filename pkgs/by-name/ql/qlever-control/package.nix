{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "qlever-control";
  version = "0.5.46";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlever-control";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vXSVrNfz4gRBCrTi0D+sXtfsAZwv7HO67zs7wh98cOY=";
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
