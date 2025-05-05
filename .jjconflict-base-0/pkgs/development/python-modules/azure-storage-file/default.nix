{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-storage-common,
  isPy3k,
  futures ? null,
}:

buildPythonPackage rec {
  pname = "azure-storage-file";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3559b9c7ab13450c66ea833eb82c28233bee24f1bd8ca19aa7d27f8c23d5bc53";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ] ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the file service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
