{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "git-of-theseus";
  version = "0.3.4";

  # Source is not published to PyPI, have to use fetchFromGitHub.
  # Also, version tags are inconsistently used, so we have to use a commit hash.
  # i.e. https://github.com/erikbern/git-of-theseus/commit/1d77f082a9b25fb3a0c541641722cd4836135362#commitcomment-141438900
  src = fetchFromGitHub {
    owner = "erikbern";
    repo = pname;
    rev = "961bda027ffa9fcd8bbe99d5b8809cc0eaa86464";
    hash = "sha256-FZXLJbximJWrDyuRril6whlOYWppGLns3k8sDNRmOuI=";
  };

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
  ];
  dependencies = with python3Packages; [
    gitpython
    numpy
    tqdm
    wcmatch
    pygments
    matplotlib
  ];

  meta = {
    description = "Analyze how a Git repo grows over time";
    homepage = "https://github.com/erikbern/git-of-theseus";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "git-of-theseus-analyze";
    maintainers = with lib.maintainers; [ ofalvai ];
  };
}
