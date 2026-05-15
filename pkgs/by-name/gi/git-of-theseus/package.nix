{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication {
  pname = "git-of-theseus";
  version = "unstable-2023-11-25";

  src = fetchFromGitHub {
    owner = "erikbern";
    repo = "git-of-theseus";
    rev = "961bda027ffa9fcd8bbe99d5b8809cc0eaa86464";
    hash = "sha256-FZXLJbximJWrDyuRril6whlOYWppGLns3k8sDNRmOuI=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    gitpython
    numpy
    tqdm
    wcmatch
    pygments
    matplotlib
  ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "git_of_theseus" ];

  meta = {
    description = "Analyze how a Git repo grows over time";
    homepage = "https://github.com/erikbern/git-of-theseus";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "git-of-theseus-analyze";
    maintainers = with lib.maintainers; [ ofalvai ];
  };
}
