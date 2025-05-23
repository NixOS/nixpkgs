{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
  qt5,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

python3Packages.buildPythonApplication rec {
  pname = "kohighlights";
  version = "2.3.1.0";

  src = fetchFromGitHub {
    owner = "noembryo";
    repo = "KoHighlights";
    tag = "v${version}";
    hash = "sha256-JxUVv2gq/AcNbikF5ix1KjbCILW3fQ1PBKMlrJH3lsk=";
  };

  dontWrapPythonPrograms = true;
  dontBuild = true;
  format = "other";

  buildInputs =
    [
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/KoHighlights
    cp -r * $out/share/KoHighlights
    makeWrapper ${python3.interpreter} $out/bin/KoHighlights \
      --add-flags "$out/share/KoHighlights/main.py" \
      --set PYTHONPATH "${python3Packages.makePythonPath dependencies}"

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
