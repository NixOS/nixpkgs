{
  lib,
  fetchFromGitHub,
  python3Packages,
  awscli,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-remote-codecommit";
  version = "1.17";
  format = "setuptools";
  disabled = !python3Packages.isPy3k;

  # The check dependency awscli has some overrides
  # which yield a different botocore.
  # This results in a duplicate version during installation
  # of the wheel, even though it does not matter
  # because it is only a test dependency.
  catchConflicts = false;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "git-remote-codecommit";
    tag = version;
    hash = "sha256-8heI0Oyfhuvshedw+Eqmwd+e9cOHdDt4O588dplqv/k=";
  };

  dependencies = with python3Packages; [ botocore ];

  nativeCheckInputs =
    [
      awscli
    ]
    ++ (with python3Packages; [
      pytestCheckHook
      mock
      flake8
      tox
    ]);

  meta = {
    description = "Git remote prefix to simplify pushing to and pulling from CodeCommit";
    maintainers = [ lib.maintainers.zaninime ];
    homepage = "https://github.com/awslabs/git-remote-codecommit";
    license = lib.licenses.asl20;
    mainProgram = "git-remote-codecommit";
  };
}
