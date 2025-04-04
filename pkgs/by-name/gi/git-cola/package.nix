{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  gettext,
  git,
  qt5,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-cola";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    tag = "v${version}";
    hash = "sha256-1y/fYqvsPpgCEakL7XepI9SVPFgmk1m795uMPv1WgNc=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ qt5.qtwayland ];

  propagatedBuildInputs =
    [ git ]
    ++ (with python3Packages; [
      setuptools
      pyqt5
      qtpy
      send2trash
      polib
    ]);

  nativeBuildInputs = [
    gettext
    qt5.wrapQtAppsHook
    python3Packages.setuptools-scm
  ];

  nativeCheckInputs = [
    git
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  disabledTestPaths = [
    "qtpy/"
    "contrib/win32"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "cola/inotify.py" ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sleek and powerful Git GUI";
    homepage = "https://git-cola.github.io/";
    changelog = "https://github.com/git-cola/git-cola/blob/v${version}/CHANGES.rst";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    mainProgram = "git-cola";
  };
}
