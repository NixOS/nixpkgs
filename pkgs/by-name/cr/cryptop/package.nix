{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cryptop";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "0akrrz735vjfrm78plwyg84vabj0x3qficq9xxmy9kr40fhdkzpb";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    setuptools
    requests
    requests-cache
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = "https://github.com/huwwp/cryptop";
    description = "Command line Cryptocurrency Portfolio";
    license = lib.licenses.mit;
    mainProgram = "cryptop";
  };
})
