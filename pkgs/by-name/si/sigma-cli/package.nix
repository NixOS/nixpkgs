{
  lib,
  fetchFromGitHub,
  python3,
<<<<<<< HEAD
  writableTmpDirAsHomeHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigma-cli";
<<<<<<< HEAD
  version = "2.0.0";
=======
  version = "1.0.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "sigma-cli";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-styE30IO5g3KoJ3IxdYiiu9xqh0OeD59WWcLk42wOCo=";
  };

  pythonRelaxDeps = [ "click" ];
=======
    hash = "sha256-BINKEptzdfEJPJAfPoYWiDXdmVnG7NYVaQar7dz4Ptk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '= "^' '= ">='
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    click
    colorama
    prettytable
    pysigma
    pysigma-backend-elasticsearch
    pysigma-backend-insightidr
    pysigma-backend-opensearch
    pysigma-backend-qradar
    pysigma-backend-splunk
    pysigma-backend-loki
    pysigma-pipeline-crowdstrike
    pysigma-pipeline-sysmon
    pysigma-pipeline-windows
  ];

<<<<<<< HEAD
  # Starting with 2.0.0 the tests wants to fetch the MITRE data
  doCheck = false;

  pythonImportsCheck = [ "sigma.cli" ];

  meta = {
    description = "Sigma command line interface";
    homepage = "https://github.com/SigmaHQ/sigma-cli";
    changelog = "https://github.com/SigmaHQ/sigma-cli/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ fab ];
=======
  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    "test_plugin_list"
    "test_plugin_list_filtered"
    "test_plugin_list_search"
    "test_plugin_install_notexisting"
    "test_plugin_install"
    "test_plugin_uninstall"
    "test_backend_option_unknown_by_backend"
    # Tests require network access
    "test_check_with_issues"
    "test_plugin_show_identifier"
    "test_plugin_show_nonexisting"
    "test_plugin_show_uuid"
    # Tests compare STDOUT results
    "test_check_valid"
    "test_check_stdin"
    "test_check_exclude"
  ];

  disabledTestPaths = [
    # AssertionError
    "tests/test_analyze.py"
    "tests/test_convert.py"
    "tests/test_filters.py"
  ];

  pythonImportsCheck = [ "sigma.cli" ];

  meta = with lib; {
    description = "Sigma command line interface";
    homepage = "https://github.com/SigmaHQ/sigma-cli";
    changelog = "https://github.com/SigmaHQ/sigma-cli/releases/tag/${src.tag}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sigma";
  };
}
