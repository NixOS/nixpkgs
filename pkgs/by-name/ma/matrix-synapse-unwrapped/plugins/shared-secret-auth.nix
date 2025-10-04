{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matrix-synapse-unwrapped,
  twisted,
}:

buildPythonPackage rec {
  pname = "matrix-synapse-shared-secret-auth";
  version = "2.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "devture";
    repo = "matrix-synapse-shared-secret-auth";
    rev = version;
    sha256 = "sha256-ZMEUBC2Y4J1+4tHfsMxqzTO/P1ef3aB81OAhEs+Tdc4=";
  };

  doCheck = false;
  pythonImportsCheck = [ "shared_secret_authenticator" ];

  buildInputs = [ matrix-synapse-unwrapped ];
  propagatedBuildInputs = [ twisted ];

  meta = with lib; {
    description = "Shared Secret Authenticator password provider module for Matrix Synapse";
    homepage = "https://github.com/devture/matrix-synapse-shared-secret-auth";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
