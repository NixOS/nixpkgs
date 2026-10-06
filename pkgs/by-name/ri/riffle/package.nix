{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "riffle";
  version = "1.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Naved124";
    repo = "riffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hH9zUjULqeohUXaj67P2CMDzbZBkZajfW2M8JGH5HaM=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    pyqt6
    pyqt6-webengine
    beautifulsoup4
  ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm644 packaging/flashcard-viewer.desktop $out/share/applications/flashcard-viewer.desktop
    substituteInPlace $out/share/applications/flashcard-viewer.desktop \
      --replace-fail "@EXEC@" "flashcard-viewer"
    install -Dm644 flashcard_viewer/ui/icon.png $out/share/icons/hicolor/512x512/apps/flashcard-viewer.png
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  pythonImportsCheck = [ "flashcard_viewer" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop app for studying HTML and React flashcard decks with quizzes and progress tracking";
    homepage = "https://github.com/Naved124/riffle";
    changelog = "https://github.com/Naved124/riffle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ naved124 ];
    mainProgram = "flashcard-viewer";
    platforms = lib.platforms.linux;
  };
})
