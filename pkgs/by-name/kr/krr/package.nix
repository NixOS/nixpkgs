{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  testers,
  krr,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "krr";
  version = "1.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1wCvoqlFBgC7SSPdq13q4CjR/rJnhv5g/xrty9YUQtg=";
  };

  patches = [
    # Upgrade to Pydantic v2
    # https://github.com/robusta-dev/krr/pull/512
    (fetchpatch {
      url = "https://github.com/robusta-dev/krr/pull/512/commits/64f8242c6f7eea3ece50f1a51eb7a1278279ae2e.patch";
      # requirements.txt is unused by the nixpkgs build (we use pyproject.toml)
      # and doesn't apply cleanly to the v1.28.0 tag.
      excludes = [ "requirements.txt" ];
      hash = "sha256-Bxf/09FslVfG4VARFDCpn0byadFhq3SrrIvKwt4pu9A=";
    })
  ];

  postPatch = ''
    substituteInPlace robusta_krr/__init__.py \
      --replace-fail 'dev' '${finalAttrs.version}'

    substituteInPlace pyproject.toml \
      --replace-fail '1.8.2-dev' '${finalAttrs.version}'
  '';

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Transitive dependency version pins, not direct imports
    "idna"
    "setuptools"
    "urllib3"
    "zipp"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    alive-progress
    cachetools
    kubernetes
    numpy
    pandas
    prometheus-api-client
    prometrix
    pydantic
    pydantic-settings
    pyyaml
    requests
    slack-sdk
    tenacity
    typer
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  # Tests require a Kubernetes cluster and use deprecated click API (mix_stderr)
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
    changelog = "https://github.com/robusta-dev/krr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "krr";
  };
})
