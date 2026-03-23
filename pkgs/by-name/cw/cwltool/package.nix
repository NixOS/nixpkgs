{
  lib,
  fetchFromGitHub,
  nodejs,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cwltool";
  version = "3.1.20251031082601";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwltool";
    tag = finalAttrs.version;
    hash = "sha256-avRNOdL4Ig2cYQWh8SqX/KWfgXyVg0TVfVFrlqzUCLA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "PYTEST_RUNNER + " "" \
      --replace-fail "ruamel.yaml >= 0.16, < 0.19" "ruamel.yaml"
    substituteInPlace pyproject.toml \
      --replace-fail "mypy==1.18.2" "mypy" \
      --replace-fail "ruamel.yaml>=0.16.0,<0.19" "ruamel.yaml"
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    argcomplete
    bagit
    coloredlogs
    cwl-utils
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

  nativeCheckInputs = with python3Packages; [
    mock
    nodejs
    pytest-mock
    pytest-httpserver
    pytest-xdist
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "prov"
    "rdflib"
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
  ]
  ++ lib.optionals (stdenv.isAarch64 && stdenv.isLinux) [
    "test_singularity"
  ]
  ++ lib.optionals (stdenv.isx86_64 && stdenv.isDarwin) [
    "test_cache_default_literal_file"
    "test_js_console_cmd_line_tool"
    "test_bad_basecommand"
    "test_optional_numeric_output_0"
  ];

  pythonImportsCheck = [
    "cwltool"
  ];

  meta = {
    description = "Common Workflow Language reference implementation";
    homepage = "https://www.commonwl.org";
    changelog = "https://github.com/common-workflow-language/cwltool/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veprbl ];
    mainProgram = "cwltool";
  };
})
