{
  lib,
  fetchFromGitHub,
  qt6,
  legendary-gl,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "rare";
  version = "1.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RareDevs";
    repo = "Rare";
    tag = version;
    hash = "sha256-RYPPR1nBBG7c7Eq8A+vc6OE33JIpe9VqgjDp9YCZz9k=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    legendary-gl
    python3Packages.pyside6
    python3Packages.vdf
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    orjson
    pypresence
    qtawesome
    requests
  ];

  dontWrapQtApps = true;

  postPatch = ''
    # PySide6-Essentials is a smaller version of PySide6, but the name mismatch breaks build
    substituteInPlace pyproject.toml \
      --replace-fail "PySide6-Essentials" "pyside6"
  '';

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
