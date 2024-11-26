{
  lib,
  buildPythonPackage,
  chromadb,
  fetchPypi,
  llama-index-core,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-chroma";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_chroma";
    inherit version;
    hash = "sha256-xel5WR0JrckfCbCPsfUj08/jDu488T5T2ihUDK6nNmo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    chromadb
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.chroma" ];

  meta = with lib; {
    description = "LlamaIndex Vector Store Integration for Chroma";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-chroma";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
