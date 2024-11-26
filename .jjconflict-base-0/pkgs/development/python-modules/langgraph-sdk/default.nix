{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  httpx,
  httpx-sse,
  orjson,

  # passthru
  writeScript,
}:

buildPythonPackage rec {
  pname = "langgraph-sdk";
  version = "0.1.43";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "sdk==${version}";
    hash = "sha256-mG04V36Aa5Df5pUgr+xWej8i2XYx+O/N61sSzxwN9Go=";
  };

  sourceRoot = "${src.name}/libs/sdk-py";

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    httpx-sse
    orjson
  ];

  disabledTests = [ "test_aevaluate_results" ]; # Compares execution time to magic number

  pythonImportsCheck = [ "langgraph_sdk" ];

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix-update

      set -eu -o pipefail +e
      nix-update --commit --version-regex '(.*)' python3Packages.langgraph
      nix-update --commit --version-regex 'sdk==(.*)' python3Packages.langgraph-sdk
      nix-update --commit --version-regex 'checkpoint==(.*)' python3Packages.langgraph-checkpoint
      nix-update --commit --version-regex 'checkpointduckdb==(.*)' python3Packages.langgraph-checkpoint-duckdb
      nix-update --commit --version-regex 'checkpointpostgres==(.*)' python3Packages.langgraph-checkpoint-postgres
      nix-update --commit --version-regex 'checkpointsqlite==(.*)' python3Packages.langgraph-checkpoint-sqlite
    '';
  };

  meta = {
    description = "SDK for interacting with the LangGraph Cloud REST API";
    homepage = "https://github.com/langchain-ai/langgraphtree/main/libs/sdk-py";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/sdk==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
