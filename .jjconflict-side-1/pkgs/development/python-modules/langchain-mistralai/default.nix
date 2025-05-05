{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  tokenizers,
  httpx,
  httpx-sse,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-mistralai";
  version = "0.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-mistralai==${version}";
    hash = "sha256-1oH9GRvjYv/YzedKXeWgw5nwNgMQ9mSNkmZ2xwPekXc=";
  };

  sourceRoot = "${src.name}/libs/partners/mistralai";

  build-system = [ pdm-backend ];

  dependencies = [
    langchain-core
    tokenizers
    httpx
    httpx-sse
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

  pythonImportsCheck = [ "langchain_mistralai" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-mistralai==([0-9.]+)"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-mistralai/releases/tag/langchain-mistralai==${version}";
    description = "Build LangChain applications with mistralai";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/mistralai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
