{
  stdenv,
  lib,
  fetchFromGitHub,
  python312Packages,
  qt5,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  python3Packages = python312Packages;
in
python3Packages.buildPythonApplication rec {
  pname = "kohighlights";
  version = "2.3.1.0";
  pyproject = false; # manual install

  src = fetchFromGitHub {
    owner = "noembryo";
    repo = "KoHighlights";
    tag = "v${version}";
    hash = "sha256-JxUVv2gq/AcNbikF5ix1KjbCILW3fQ1PBKMlrJH3lsk=";
  };

  dontWrapPythonPrograms = true;
  dontBuild = true;

  buildInputs = [
    qt5.qtbase
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    qt5.qtwayland
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    makeWrapper
    copyDesktopItems
  ];

  dependencies = with python3Packages; [
    pyside2
    beautifulsoup4
    packaging
    requests
    future
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "kohighlights";
      desktopName = "KoHighlights";
      exec = meta.mainProgram;
      comment = meta.description;
      categories = [ "Utility" ];
    })
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/KoHighlights
    rm -rf docs screens
    cp -r * $out/share/KoHighlights
    makeWrapper ${python3Packages.python.interpreter} $out/bin/KoHighlights \
      --add-flags "$out/share/KoHighlights/main.py" \
      --set PYTHONPATH "${python3Packages.makePythonPath dependencies}" \
      ''${qtWrapperArgs[@]}

    runHook postInstall
  '';

  meta = {
    description = "Utility for viewing and/or exporting KOReader's highlights";
    homepage = "https://github.com/noembryo/KoHighlights";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "KoHighlights";
  };
}
