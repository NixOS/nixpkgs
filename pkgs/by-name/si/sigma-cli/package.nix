{
  lib,
  fetchFromGitHub,
  python3,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sigma-cli";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "sigma-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7zPB2eb+PeJ0xKygf/oRGZfntHiHHkk9L5Pr7oUfvkY=";
  };

  pythonRelaxDeps = [ "click" ];

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

  # Starting with 2.0.0 the tests wants to fetch the MITRE data
  doCheck = false;

  pythonImportsCheck = [ "sigma.cli" ];

  meta = {
    description = "Sigma command line interface";
    homepage = "https://github.com/SigmaHQ/sigma-cli";
    changelog = "https://github.com/SigmaHQ/sigma-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sigma";
  };
})
