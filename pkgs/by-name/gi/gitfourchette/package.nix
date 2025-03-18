{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
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
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    pygit2
  ];

  optional-dependencies = with python3.pkgs; {
    memory-indicator = [
      psutil
    ];
    pygments = [
      pygments
    ];
    pyqt5 = [
      pyqt5
    ];
    pyqt6 = [
      pyqt6
    ];
    pyside6 = [
      pyside6
    ];
    test = [
      pytest
      pytest-cov
      pytest-qt
      pytest-xdist
      ruff
    ];
  };

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
