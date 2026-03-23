{
  lib,
  python3,
  fetchFromGitHub,
  testers,
  krr,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "krr";
  version = "1.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1wCvoqlFBgC7SSPdq13q4CjR/rJnhv5g/xrty9YUQtg=";
  };

  pythonRelaxDeps = [
    "idna"
    "kubernetes"
    "numpy"
    "pandas"
    "prometheus-api-client"
    "pydantic"
    "pyyaml"
    "setuptools"
    "tenacity"
    "typing-extensions"
    "typer"
  ];

  dependencies = with python3.pkgs; [
    aiostream
    alive-progress
    cachetools
    kubernetes
    numpy
    poetry-core
    prometheus-api-client
    prometrix
    pydantic_1
    pyyaml
    slack-sdk
    tenacity
    typer
    typing-extensions
    setuptools
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-asyncio
    pytestCheckHook
  ];

  # https://github.com/robusta-dev/krr/issues/435
  doCheck = false;

  pythonImportsCheck = [
    "robusta_krr"
  ];

  passthru.tests.version = testers.testVersion {
    package = krr;
    command = "krr version";
  };

  meta = {
    description = "Prometheus-based Kubernetes resource recommendations";
    longDescription = ''
      Robusta KRR (Kubernetes Resource Recommender) is a CLI tool for optimizing
      resource allocation in Kubernetes clusters. It gathers Pod usage data from
      Prometheus and recommends requests and limits for CPU and memory. This
      reduces costs and improves performance.
    '';
    homepage = "https://github.com/robusta-dev/krr";
    changelog = "https://github.com/robusta-dev/krr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ themadbit ];
    mainProgram = "krr";
  };
})
