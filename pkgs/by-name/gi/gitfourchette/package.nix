{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gitfourchette";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jorio";
    repo = "gitfourchette";
    rev = "v${version}";
    hash = "sha256-VOVwg590e/j8HwM5fy6T8Y9yccsFk8ps0NzYD1muSEo=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  dependencies = with python3Packages; [
    pygit2
    pyside6
    pygments
    psutil
  ];


  pythonImportsCheck = [
    "gitfourchette"
  ];

  meta = {
    description = "The comfortable Git UI for Linux";
    homepage = "https://github.com/jorio/gitfourchette";
    changelog = "https://github.com/jorio/gitfourchette/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "gitfourchette";
  };
}
