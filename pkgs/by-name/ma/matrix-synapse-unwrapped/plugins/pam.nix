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

  src = fetchFromGitHub {
    owner = "14mRh4X0r";
    repo = "matrix-synapse-pam";
    rev = "v${version}";
    sha256 = "0jgz49cwiyih5cg3hr4byva04zjnq8aj7rima9874la9fc5sd2wf";
  };

  propagatedBuildInputs = [
    twisted
    python-pam
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pam_auth_provider" ];

  meta = with lib; {
    description = "PAM auth provider for the Synapse Matrix server";
    homepage = "https://github.com/14mRh4X0r/matrix-synapse-pam";
    license = licenses.eupl12;
    maintainers = [ ];
  };
}
