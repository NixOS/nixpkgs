{
  buildPythonPackage,
  poetry-core,
  llama-index-agent-openai,
  llama-index-cli,
  llama-index-core,
  llama-index-embeddings-openai,
  llama-index-indices-managed-llama-cloud,
  llama-index-legacy,
  llama-index-llms-openai,
  llama-index-multi-modal-llms-openai,
  llama-index-program-openai,
  llama-index-question-gen-openai,
  llama-index-readers-file,
  llama-index-readers-llama-parse,
}:

buildPythonPackage {
  pname = "llama-index";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "llama-index-core"
  ];

  dependencies = [
    llama-index-agent-openai
    llama-index-cli
    llama-index-core
    llama-index-embeddings-openai
    llama-index-indices-managed-llama-cloud
    llama-index-legacy
    llama-index-llms-openai
    llama-index-multi-modal-llms-openai
    llama-index-program-openai
    llama-index-question-gen-openai
    llama-index-readers-file
    llama-index-readers-llama-parse
  ];

  pythonImportsCheck = [ "llama_index" ];
}
