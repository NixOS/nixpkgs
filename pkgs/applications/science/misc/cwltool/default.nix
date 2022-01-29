{ lib
, fetchFromGitHub
, git
, nodejs
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cwltool";
  version = "3.1.20220124184855";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = pname;
    rev = version;
    sha256 = "0b0mxminfijbi3d9sslhwhs8awnagdsx8d2wh9x9ipdpwipihpmb";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "ruamel.yaml >= 0.15, < 0.17.18" "ruamel.yaml" \
      --replace "prov == 1.5.1" "prov" \
      --replace "setup_requires=PYTEST_RUNNER," ""
  '';

  nativeBuildInputs = [
    git
  ];

  propagatedBuildInputs = with python3.pkgs; [
    argcomplete
    bagit
    coloredlogs
    mypy-extensions
    prov
    psutil
    pydot
    rdflib
    requests
    ruamel-yaml
    schema-salad
    shellescape
    typing-extensions
  ];

  checkInputs = with python3.pkgs; [
    mock
    nodejs
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    "test_content_types"
    "test_env_filtering"
    "test_http_path_mapping"
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
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
