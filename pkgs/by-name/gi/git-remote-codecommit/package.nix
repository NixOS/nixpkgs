{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-remote-codecommit";
  version = "1.17";
  pyproject = true;
  disabled = !python3Packages.isPy3k;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "git-remote-codecommit";
    tag = finalAttrs.version;
    hash = "sha256-8heI0Oyfhuvshedw+Eqmwd+e9cOHdDt4O588dplqv/k=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ botocore ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    mock
    flake8
    tox
  ];

  # Requires AWS CLI v1
  disabledTestPaths = [ "test/context_test.py" ];

  meta = {
    description = "Git remote prefix to simplify pushing to and pulling from CodeCommit";
    maintainers = [ lib.maintainers.zaninime ];
    homepage = "https://github.com/awslabs/git-remote-codecommit";
    license = lib.licenses.asl20;
    mainProgram = "git-remote-codecommit";
  };
})
