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
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "why2025-datenzone";
    repo = "pretalx-llm";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KnL4X24RESAgO0Oh1k9c+K4zaho6CEFHMQvDeRdLBzs=";
=======
    hash = "sha256-Ga6Itvc+yL+p6K7w6WYTeNfxahaohDidDWnt0GtcWEM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
