{
  fetchFromGitHub,
  krr,
  lib,
  python3,
  testers,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "krr";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "krr";
    rev = "refs/tags/v${version}";
    hash = "sha256-CKOkwk5vvRtwAenmuoMCIce87f/0Tv+vQzPG1ebh4/4=";
  };

  pythonRelaxDeps = [
    "kubernetes"
    "prometheus-api-client"
    "pydantic"
    "requests"
    "typer"
    "typing-extensions"
  ];

  postPatch = ''
    sed -i pyproject.toml -e 's/^version =.*/version = \"${version}\"/'
    sed -i robusta_krr/__init__.py -e 's/^__version__ =.*/__version__ = \"${version}\"/'
  '';

  propagatedBuildInputs =
    with python3.pkgs;
    [
      alive-progress
      kubernetes
      numpy
      poetry-core
      prometheus-api-client
      prometrix
      pydantic_1
      slack-sdk
      typer
    ]
    ++ typer.optional-dependencies.all;

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "robusta_krr" ];

  # They just fail.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = krr;
    command = "krr version";
  };

  meta = with lib; {
    description = "Prometheus-based Kubernetes resource recommendations";
    longDescription = ''
      Robusta KRR (Kubernetes Resource Recommender) is a CLI tool for optimizing
      resource allocation in Kubernetes clusters. It gathers Pod usage data from
      Prometheus and recommends requests and limits for CPU and memory. This
      reduces costs and improves performance.
    '';
    homepage = "https://github.com/robusta-dev/krr";
    changelog = "https://github.com/robusta-dev/krr/releases/tag/v${src.rev}";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    mainProgram = "krr";
  };
}
