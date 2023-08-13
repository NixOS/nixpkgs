{ lib, fetchFromGitHub, python3Packages, awscli }:

with python3Packages;

buildPythonApplication rec {
  pname = "git-remote-codecommit";
  version = "1.15.1";
  disabled = !isPy3k;

  # The check dependency awscli has some overrides
  # which yield a different botocore.
  # This results in a duplicate version during installation
  # of the wheel, even though it does not matter
  # because it is only a test dependency.
  catchConflicts = false;

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = version;
    sha256 = "1vvp7i8ghmq72v57f6smh441h35xnr5ar628q2mr40bzvcifwymw";
  };

  propagatedBuildInputs = [ botocore ];

  nativeCheckInputs = [ pytest mock flake8 tox awscli ];

  checkPhase = ''
    pytest
  '';

  meta = {
    description =
      "Git remote prefix to simplify pushing to and pulling from CodeCommit";
    maintainers = [ lib.maintainers.zaninime ];
    homepage = "https://github.com/awslabs/git-remote-codecommit";
    license = lib.licenses.asl20;
  };
}
