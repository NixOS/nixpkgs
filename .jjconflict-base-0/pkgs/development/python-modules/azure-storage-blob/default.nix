{
  lib,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "12.25.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_storage_blob";
    inherit version;
    hash = "sha256-TylN3JvEeQmsZriTS9JrUNIAAnixCtgswQl2T9xuDjs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-blob_${version}/sdk/storage/azure-storage-blob/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      cmcdragonkai
      maxwilson
    ];
  };
}
