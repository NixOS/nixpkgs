{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  pdm-backend,

  # dependencies
  aiohttp,
  fireworks-ai,
  langchain-core,
  openai,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-fireworks";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-fireworks==${version}";
    hash = "sha256-OZou323FAk2I4YuQV7sllbzDwFQWy/90FK3gIHnEBd0=";
  };

  sourceRoot = "${src.name}/libs/partners/fireworks";

  build-system = [ pdm-backend ];

  dependencies = [
    aiohttp
    fireworks-ai
    langchain-core
    openai
    pydantic
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_fireworks" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-fireworks==([0-9.]+)"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-fireworks==${version}";
    description = "Build LangChain applications with Fireworks";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/fireworks";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
