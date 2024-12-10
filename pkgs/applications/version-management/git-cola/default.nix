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
  version = "4.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    rev = "v${version}";
    hash = "sha256-93aayGGMgkSghTpx8M5Cfbxf2szAwrSzuoWK6GCTqZ8=";
  };

  buildInputs = lib.optionals stdenv.isLinux [
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
    ++ lib.optionals stdenv.isDarwin [
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
    description = "A sleek and powerful Git GUI";
    license = licenses.gpl2;
    maintainers = [ maintainers.bobvanderlinden ];
    mainProgram = "git-cola";
  };
}
