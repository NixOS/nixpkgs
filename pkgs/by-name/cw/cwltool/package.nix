{
  lib,
  fetchFromGitHub,
  nodejs,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cwltool";
  version = "3.3.20261106131234";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwltool";
    tag = finalAttrs.version;
    hash = "sha256-oN64oZjivhlRdJtt+MSnwL+2eo159WbXQZvXycdryjA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "PYTEST_RUNNER + " ""
    substituteInPlace pyproject.toml \
      --replace-fail "mypy==2.4.1" "mypy"
  '';

  pythonRelaxDeps = [
    "prov"
    "rdflib"
  ];

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
    distutils
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
    # Assertion errors
    "test_bare_listing"
    "test_main_parsed_args_provenance"
    "test_bare_listing_null_return"
  ];

  disabledTestPaths = [
    "tests/test_udocker.py"
    "tests/test_provenance.py"
    "tests/test_examples.py"
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
