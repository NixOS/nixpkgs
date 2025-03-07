{ lib, buildPythonApplication, fetchPypi, requests, requests-cache, setuptools }:

buildPythonApplication rec {
  pname = "cryptop";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0akrrz735vjfrm78plwyg84vabj0x3qficq9xxmy9kr40fhdkzpb";
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
