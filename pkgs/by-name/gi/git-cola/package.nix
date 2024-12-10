{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  gettext,
  git,
  qt5,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-cola";
  version = "4.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    hash = "sha256-8OErZ6uKTWE245BoBu9lQyTLA43DfWaYDv3wbPWaufg=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    qt5.qtwayland
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    git
    pyqt5
    qtpy
    send2trash
    polib
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
    gettext
    qt5.wrapQtAppsHook
  ];

  nativeCheckInputs = with python3Packages; [
    git
    pytestCheckHook
  ];

  disabledTestPaths =
    [
      "qtpy/"
      "contrib/win32"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "cola/inotify.py"
    ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/git-cola/git-cola";
    description = "Sleek and powerful Git GUI";
    license = licenses.gpl2;
    maintainers = [ maintainers.bobvanderlinden ];
    mainProgram = "git-cola";
  };
}
