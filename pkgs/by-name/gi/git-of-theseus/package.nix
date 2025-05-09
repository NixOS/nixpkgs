{
  python3,
  fetchFromGitHub,
  lib,
}:
python3.pkgs.buildPythonApplication {
  pyproject = true;

  pname = "git-of-theseus";
  version = "0-unstable-2023-02-13";
  src = fetchFromGitHub {
    rev = "961bda027ffa9fcd8bbe99d5b8809cc0eaa86464";
    owner = "erikbern";
    repo = "git-of-theseus";
    fetchSubmodules = false;
    sha256 = "sha256-FZXLJbximJWrDyuRril6whlOYWppGLns3k8sDNRmOuI=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  meta = {
    description = "Analyze how a Git repo grows over time";
    homepage = "https://github.com/erikbern/git-of-theseus";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ fzakaria ];
    mainProgram = "git-of-theseus";
  };
}
