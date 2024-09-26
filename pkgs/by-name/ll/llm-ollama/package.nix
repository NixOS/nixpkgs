{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "llm-ollama";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "taketwo";
    repo = "llm-ollama";
    rev = "refs/tags/${version}";
    hash = "sha256-QxmFgiy+Z5MNtnf2nvGndZk2MMuMhkOfofUsxCoh7J0=";
  };

  disabled = python3Packages.pythonOlder "3.8";

  build-system = [
    python3Packages.setuptools
    # Follows the reasoning from https://github.com/NixOS/nixpkgs/pull/327800#discussion_r1681586659 about including llm in build-system
    python3Packages.llm
  ];

  dependencies = (
    with python3Packages;
    [
      click
      ollama
      pydantic
    ]
  );

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  # These tests try to access the filesystem and fail
  disabledTests = [
    "test_registered_model"
    "test_registered_models_when_ollama_is_down"
  ];

  pythonImportCheck = [
    "llm_ollama"
  ];

  meta = with lib; {
    description = "LLM plugin providing access to Ollama models using HTTP API";
    homepage = "https://github.com/taketwo/llm-ollama";
    changelog = "https://github.com/taketwo/llm-ollama/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ erethon ];
  };
}
