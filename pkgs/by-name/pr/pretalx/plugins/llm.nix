{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  ollama,
  openai,
  python-redis-lock,
  umap-learn,
}:

buildPythonPackage rec {
  pname = "pretalx-llm";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "why2025-datenzone";
    repo = "pretalx-llm";
    rev = "v${version}";
    hash = "sha256-Ga6Itvc+yL+p6K7w6WYTeNfxahaohDidDWnt0GtcWEM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    ollama
    openai
    python-redis-lock
    umap-learn
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretalx_llm"
  ];

  meta = {
    description = "LLM support for Pretalx";
    homepage = "https://github.com/why2025-datenzone/pretalx-llm";
    changelog = "https://github.com/why2025-datenzone/pretalx-llm/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
