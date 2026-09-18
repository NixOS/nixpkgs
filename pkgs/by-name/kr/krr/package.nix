{
  lib,
  python313Packages,
  fetchFromGitHub,
  testers,
  krr,
}:

let
  pythonPackages = python313Packages.overrideScope (
    final: prev: {
      # KRR requires Pydantic 1, which is incompatible with Python 3.14.
      # https://github.com/robusta-dev/krr/pull/512
      # https://github.com/pydantic/pydantic/pull/12263
      prometrix = prev.prometrix.override { pydantic = final.pydantic_1; };
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "krr";
  version = "1.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1wCvoqlFBgC7SSPdq13q4CjR/rJnhv5g/xrty9YUQtg=";
  };

  postPatch = ''
    substituteInPlace robusta_krr/__init__.py \
      --replace-fail 'dev' '${finalAttrs.version}'

    substituteInPlace pyproject.toml \
      --replace-fail '1.8.2-dev' '${finalAttrs.version}'
  '';

  pythonRelaxDeps = [
    # The enabled tests and import check pass with nixpkgs' versions.
    # Exact upstream pins and ranges do not match the versions packaged by nixpkgs.
    "idna"
    "pandas"
    "prometheus-api-client"
    "prometrix"
    "pyyaml"
    "typing-extensions"
    "kubernetes"
    "numpy"
    "typer"
  ];

  pythonRemoveDeps = [
    # Added upstream to pin transitive dependencies for CVE remediation:
    # https://github.com/robusta-dev/krr/commit/089285b533635015f092ecc3603416d67c1e8bcc
    # KRR does not import them at runtime.
    "setuptools"
    "zipp"
  ];

  build-system = with pythonPackages; [
    poetry-core
  ];

  dependencies = with pythonPackages; [
    alive-progress
    cachetools
    kubernetes
    numpy
    pandas
    prometheus-api-client
    prometrix
    pydantic_1
    pyyaml
    requests
    slack-sdk
    tenacity
    typer
    urllib3
  ];

  nativeCheckInputs = with pythonPackages; [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Click no longer accepts CliRunner(mix_stderr = false).
    # https://github.com/robusta-dev/krr/issues/544
    "tests/test_krr.py"
    "tests/test_runner.py"
  ];

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
    changelog = "https://github.com/robusta-dev/krr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "krr";
  };
})
