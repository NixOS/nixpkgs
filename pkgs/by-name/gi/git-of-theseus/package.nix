{
  python3Packages,
  fetchFromGitHub,
  lib,
}:
python3Packages.buildPythonApplication {
  pname = "git-of-theseus";
  version = "0-unstable-2023-11-25";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "erikbern";
    repo = "git-of-theseus";
    rev = "961bda027ffa9fcd8bbe99d5b8809cc0eaa86464";
    hash = "sha256-FZXLJbximJWrDyuRril6whlOYWppGLns3k8sDNRmOuI=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    gitpython
    matplotlib
    numpy
    progressbar2
    pygments
    scipy
    tqdm
    wcmatch
  ];

  pythonImportsCheck = [ "git_of_theseus" ];

  # No version flag, no python tests
  doCheck = false;

  meta = {
    description = "Analyze how a Git repo grows over time";
    homepage = "https://github.com/erikbern/git-of-theseus";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fzakaria ];
    mainProgram = "git-of-theseus-analyze";
  };
}
