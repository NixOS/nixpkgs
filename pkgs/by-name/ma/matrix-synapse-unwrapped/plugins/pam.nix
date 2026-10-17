{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  twisted,
  python-pam,
}:

buildPythonPackage rec {
  pname = "matrix-synapse-pam";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "14mRh4X0r";
    repo = "matrix-synapse-pam";
    rev = "v${version}";
    hash = "sha256-joumC3NJUXJQUjXmIxXCVn4C1PaLZDgeKzD6yFki/0k=";
  };

  propagatedBuildInputs = [
    twisted
    python-pam
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pam_auth_provider" ];

  meta = {
    description = "PAM auth provider for the Synapse Matrix server";
    homepage = "https://github.com/14mRh4X0r/matrix-synapse-pam";
    license = lib.licenses.eupl12;
    maintainers = [ ];
  };
}
