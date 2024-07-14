{ lib, buildPythonApplication, fetchPypi, requests, requests-cache, setuptools }:

buildPythonApplication rec {
  pname = "cryptop";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6/7ZoAMkz+Rr7wmz6PDoQC61CXqe04tOzU7uMs7PeSo=";
  };

  propagatedBuildInputs = [ setuptools requests requests-cache ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = "https://github.com/huwwp/cryptop";
    description = "Command line Cryptocurrency Portfolio";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ bhipple ];
    mainProgram = "cryptop";
  };
}
