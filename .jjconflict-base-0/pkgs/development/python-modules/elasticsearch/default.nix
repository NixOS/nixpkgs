{
  lib,
  aiohttp,
  buildPythonPackage,
  elastic-transport,
  fetchPypi,
  hatchling,
  orjson,
  pyarrow,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "elasticsearch";
  version = "8.15.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QMDTEvit+L3IF5W8FqC1Rt31RMsfkOgpokTkeAxNv9g=";
  };

  build-system = [ hatchling ];

  dependencies = [ elastic-transport ];

  optional-dependencies = {
    requests = [ requests ];
    async = [ aiohttp ];
    orjson = [ orjson ];
    pyarrow = [ pyarrow ];
  };

  pythonImportsCheck = [ "elasticsearch" ];

  # Check is disabled because running them destroy the content of the local cluster!
  # https://github.com/elasticsearch/elasticsearch-py/tree/master/test_elasticsearch
  doCheck = false;

  meta = with lib; {
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
