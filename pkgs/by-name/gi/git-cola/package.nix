{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  gettext,
  git,
  qt6,
  versionCheckHook,
  copyDesktopItems,
  imagemagick,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-cola";
  version = "4.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "git-cola";
    repo = "git-cola";
    tag = "v${version}";
    hash = "sha256-rNu0D3mbGP9cEtVekwSgvjUoTKQkoLx6VuSbyXJEqjY=";
  };

  build-system = with python3Packages; [
    setuptools-scm
  ];

  buildInputs = [
    git
    qt6.qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  dependencies = with python3Packages; [
    polib
    pyqt6
    qtpy
    send2trash
  ];

  nativeBuildInputs = [
    gettext
    qt6.wrapQtAppsHook
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  nativeCheckInputs = [
    git
    python3Packages.pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  disabledTestPaths = [
    "qtpy/"
    "contrib/win32"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "cola/inotify.py" ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  desktopItems = [
    "share/applications/git-cola-folder-handler.desktop"
    "share/applications/git-cola.desktop"
    "share/applications/git-dag.desktop"
  ];

  postInstall = ''
    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      magick cola/icons/git-cola.svg -background none -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
    done
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
