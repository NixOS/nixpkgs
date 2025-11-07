{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  git-lfs,
}:

python3Packages.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.51.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "josegonzalez";
    repo = "python-github-backup";
    tag = version;
    hash = "sha256-XqQw2Qu5b5Gdna8krwvkYsTPbM5p1gUBV2P7JLypqVU=";
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
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${src.tag}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "github-backup";
  };
}
