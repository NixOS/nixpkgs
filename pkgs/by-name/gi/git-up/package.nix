{
  lib,
  fetchPypi,
  python3Packages,
  writableTmpDirAsHomeHook,
  gitMinimal,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-up";
  version = "2.3.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "git_up";
    inherit version;
    hash = "sha256-SncbnK6LxsleKRa/sSCm/8dsgPw/XJGvYfkcIeWYDy4=";
  };

  pythonRelaxDeps = [
    "termcolor"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  # required in PATH for tool to work
  propagatedBuildInputs = [ gitMinimal ];

  dependencies = with python3Packages; [
    colorama
    gitpython
    termcolor
  ];

  nativeCheckInputs = [
    gitMinimal
    python3Packages.pytest7CheckHook
    writableTmpDirAsHomeHook
  ];

  # git fails without email address
  preCheck = ''
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  postInstall = ''
    rm -r $out/${python3Packages.python.sitePackages}/PyGitUp/tests
  '';

  meta = {
    homepage = "https://github.com/msiemens/PyGitUp";
    description = "Git pull replacement that rebases all local branches when pulling";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.all;
    mainProgram = "git-up";
  };
}
