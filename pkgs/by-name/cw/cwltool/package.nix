{
  lib,
  fetchFromGitHub,
  git,
  nodejs,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cwltool";
  version = "3.1.20241024121129";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwltool";
    rev = "refs/tags/${version}";
    hash = "sha256-MocgfELgis9b+byeDU7mDQcXnLhaWBtvGbqm7MtRdf8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "ruamel.yaml >= 0.16, < 0.19" "ruamel.yaml" \
      --replace-fail "prov == 1.5.1" "prov" \
      --replace-fail '"schema-salad >= 8.7, < 9",' '"schema-salad",' \
      --replace-fail "PYTEST_RUNNER + " ""
    substituteInPlace pyproject.toml \
      --replace-fail "ruamel.yaml>=0.16.0,<0.18" "ruamel.yaml" \
      --replace-fail "mypy==1.13.0" "mypy"
  '';

  nativeBuildInputs =
    [
      git
    ]
    ++ (with python3.pkgs; [
      setuptools
      setuptools-scm
    ]);

  dependencies = with python3.pkgs; [
    argcomplete
    bagit
    coloredlogs
    cwl-utils
    mypy
    mypy-extensions
    prov
    psutil
    pydot
    rdflib
    requests
    ruamel-yaml
    schema-salad
    shellescape
    spython
    toml
    types-psutil
    types-requests
    typing-extensions
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    nodejs
    pytest-mock
    pytest-httpserver
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    "test_content_types"
    "test_env_filtering"
    "test_http_path_mapping"
    "test_modification_date"
  ];

  disabledTestPaths = [
    "tests/test_udocker.py"
    "tests/test_provenance.py"
  ];

  pythonImportsCheck = [
    "cwltool"
  ];

  meta = with lib; {
    description = "Common Workflow Language reference implementation";
    homepage = "https://www.commonwl.org";
    changelog = "https://github.com/common-workflow-language/cwltool/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
    mainProgram = "cwltool";
  };
}
