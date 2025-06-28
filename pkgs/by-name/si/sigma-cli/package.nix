{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigma-cli";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "sigma-cli";
    tag = "v${version}";
    hash = "sha256-BINKEptzdfEJPJAfPoYWiDXdmVnG7NYVaQar7dz4Ptk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '= "^' '= ">='
  '';

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

  pythonImportsCheck = [ "sigma.cli" ];

  meta = with lib; {
    description = "Sigma command line interface";
    homepage = "https://github.com/SigmaHQ/sigma-cli";
    changelog = "https://github.com/SigmaHQ/sigma-cli/releases/tag/${src.tag}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sigma";
  };
}
