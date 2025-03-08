{
  lib,
  fetchFromGitHub,
  git,
  nodejs,
  python3,
}:

let
  py = python3.override {
    packageOverrides = final: prev: {
      # Requires "pydot >= 1.4.1, <3",
      pydot = prev.pydot.overridePythonAttrs (old: rec {
        version = "2.0.0";
        src = old.src.override {
          inherit version;
          hash = "sha256-YCRq8hUSP6Bi8hzXkb5n3aI6bygN8J9okZ5jeh5PMjU=";
        };
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

py.pkgs.buildPythonApplication rec {
  pname = "cwltool";
  version = "3.1.20250110105449";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwltool";
    tag = version;
    hash = "sha256-V0CQiNkIw81s6e9224qcfbsOqBvMo34q+lRURpRetKs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "prov == 1.5.1" "prov" \
      --replace-fail '"schema-salad >= 8.7, < 9",' '"schema-salad",' \
      --replace-fail "PYTEST_RUNNER + " ""
  '';

  build-system = with py.pkgs; [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ git ];

  dependencies = with py.pkgs; [
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
    rich-argparse
    ruamel-yaml
    schema-salad
    shellescape
    spython
    toml
    types-psutil
    types-requests
    typing-extensions
  ];

  nativeCheckInputs = with py.pkgs; [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ veprbl ];
    mainProgram = "cwltool";
  };
}
