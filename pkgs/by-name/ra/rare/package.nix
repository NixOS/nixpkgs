{
  lib,
  fetchFromGitHub,
  qt5,
  legendary-gl,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "rare";
  version = "1.10.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RareDevs";
    repo = "Rare";
    tag = version;
    hash = "sha256-2DtI5iaK4bYdGfIEhPy52WaEqh+IJMZ6qo/348lMnLY=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    legendary-gl
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    orjson
    pypresence
    pyqt5
    qtawesome
    requests
    typing-extensions
  ];

  dontWrapQtApps = true;

  postInstall = ''
    install -Dm644 misc/rare.desktop -t $out/share/applications/
    install -Dm644 $out/${python3Packages.python.sitePackages}/rare/resources/images/Rare.png $out/share/pixmaps/rare.png
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # Project has no tests
  doCheck = false;

  meta = {
    description = "GUI for Legendary, an Epic Games Launcher open source alternative";
    homepage = "https://github.com/RareDevs/Rare";
    maintainers = with lib.maintainers; [ iedame ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "rare";
  };
}
