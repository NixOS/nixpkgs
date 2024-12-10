{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  git-lfs,
}:

python3Packages.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.46.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josegonzalez";
    repo = "python-github-backup";
    rev = "refs/tags/${version}";
    hash = "sha256-kSxkD8vWBvaT7C0sS9rs3CEP2yeWsAJ0kjPlrGezoLU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      git
      git-lfs
    ])
  ];

  # has no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "github-backup";
  };
}
