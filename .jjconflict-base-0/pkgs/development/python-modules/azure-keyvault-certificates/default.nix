{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-core,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-certificates";
  version = "4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_keyvault_certificates";
    inherit version;
    hash = "sha256-ndBPj/5AkViCgut1SAuzHlhN2ZQNCfnepn+sg2Ppflk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.keyvault.certificates" ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Certificates Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-certificates";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-keyvault-certificates_${version}/sdk/keyvault/azure-keyvault-certificates/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
