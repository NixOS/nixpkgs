{
  lib,
  azure-common,
  azure-core,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UvCSsiZ315IoDwvMI02JLJ9zjpPI4Ut0wZUQG5uicYQ=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-mgmt-core
    isodate
  ];

  # Tests are only available in mono-repo
  doCheck = false;

  pythonImportsCheck = [ "azure.synapse.artifacts" ];

  meta = with lib; {
    description = "Microsoft Azure Synapse Artifacts Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-synapse-artifacts_${version}/sdk/synapse/azure-synapse-artifacts/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
